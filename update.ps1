#!/usr/bin/env pwsh

$ErrorActionPreference = "Stop"

$FormulaDir = Join-Path $PSScriptRoot "Formula"
if (-not (Test-Path $FormulaDir)) {
    Write-Error "Formula directory not found: $FormulaDir"
    exit 1
}

$FormulaFiles = Get-ChildItem -Path $FormulaDir -Filter "*.rb"
if ($FormulaFiles.Count -eq 0) {
    Write-Host "No formula files found in $FormulaDir"
    exit 0
}

function Get-LatestVersion {
    param(
        [string]$Homepage,
        [string]$Version
    )

    if ($Homepage -match "github\.com/([^/]+)/([^/]+)") {
        $owner = $Matches[1]
        $repo = $Matches[2]

        $apiUrl = "https://api.github.com/repos/$owner/$repo/releases/latest"
        try {
            $response = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "PowerShell" } -TimeoutSec 10
            $latestVersion = $response.tag_name -replace '^v', ''
            return $latestVersion
        }
        catch {
            Write-Warning "Failed to fetch latest version for $owner/$repo : $_"
            return $null
        }
    }

    Write-Warning "Cannot determine GitHub repo from homepage: $Homepage"
    return $null
}

function Test-VersionNewer {
    param(
        [string]$CurrentVersion,
        [string]$LatestVersion
    )

    if (-not $LatestVersion) {
        return $false
    }

    try {
        $current = [version]($CurrentVersion -replace '-.*$', '')
        $latest = [version]($LatestVersion -replace '-.*$', '')
        return $latest -gt $current
    }
    catch {
        Write-Warning "Failed to parse versions: current='$CurrentVersion', latest='$LatestVersion'"
        return $false
    }
}

function Get-Checksum {
    param(
        [string]$Url,
        [string]$Version
    )

    $tempDir = [System.IO.Path]::GetTempPath()
    $tempFile = Join-Path $tempDir "download_$(Get-Random)"

    try {
        Write-Host "    Downloading: $Url"
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $Url -OutFile $tempFile -Headers @{ "User-Agent" = "PowerShell" } -TimeoutSec 60

        $hash = Get-FileHash -Path $tempFile -Algorithm SHA256
        $checksum = $hash.Hash.ToLower()

        return $checksum
    }
    catch {
        Write-Warning "    Failed to download: $_"
        return $null
    }
    finally {
        if (Test-Path $tempFile) {
            Remove-Item $tempFile -Force
        }
    }
}

function Get-FormulaUrlsAndChecksums {
    param(
        [string]$Content,
        [string]$Version
    )

    $urls = @()

    $urlPattern = 'url\s+"([^"]+)"'
    $sha256Pattern = 'sha256\s+"([a-f0-9]+)"'

    $urlMatches = [regex]::Matches($Content, $urlPattern)
    $sha256Matches = [regex]::Matches($Content, $sha256Pattern)

    for ($i = 0; $i -lt $urlMatches.Count; $i++) {
        $url = $urlMatches[$i].Groups[1].Value
        $url = $url -replace '#\{version\}', $Version
        $url = $url -replace 'v\{version\}', "v$Version"

        $sha256 = $null
        if ($i -lt $sha256Matches.Count) {
            $sha256 = $sha256Matches[$i].Groups[1].Value
        }

        $urls += @{
            Url = $url
            CurrentSha256 = $sha256
        }
    }

    return $urls
}

$updatedCount = 0

foreach ($file in $FormulaFiles) {
    Write-Host "Checking $($file.Name)..."

    $content = Get-Content $file.FullName -Raw

    if ($content -match 'version\s+"([^"]+)"') {
        $currentVersion = $Matches[1]
    }
    else {
        Write-Warning "Could not find version in $($file.Name)"
        continue
    }

    if ($content -match 'homepage\s+"([^"]+)"') {
        $homepage = $Matches[1]
    }
    else {
        Write-Warning "Could not find homepage in $($file.Name)"
        continue
    }

    $latestVersion = Get-LatestVersion -Homepage $homepage -Version $currentVersion

    if (-not $latestVersion) {
        Write-Host "  Skipping - could not determine latest version"
        continue
    }

    Write-Host "  Current: $currentVersion, Latest: $latestVersion"

    if (Test-VersionNewer -CurrentVersion $currentVersion -LatestVersion $latestVersion) {
        Write-Host "  -> Updating to $latestVersion"

        $artifacts = Get-FormulaUrlsAndChecksums -Content $content -Version $latestVersion

        $newContent = $content

        $newContent = $newContent -replace "version\s+""$currentVersion""", "version ""$latestVersion"""

        foreach ($artifact in $artifacts) {
            if ($artifact.CurrentSha256) {
                $checksum = Get-Checksum -Url $artifact.Url -Version $latestVersion
                if ($checksum) {
                    Write-Host "    New checksum: $checksum"
                    $newContent = $newContent -replace "sha256\s+""$($artifact.CurrentSha256)""", "sha256 ""$checksum"""
                }
                else {
                    Write-Warning "    Could not calculate checksum for $($artifact.Url)"
                }
            }
        }

        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        $updatedCount++
    }
    else {
        Write-Host "  Already up to date"
    }
}

Write-Host ""
Write-Host "Updated $updatedCount formula(s)"
