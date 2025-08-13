class Moonup < Formula
  version "0.3.2"
  desc "Manage multiple MoonBit installations"
  homepage "https://github.com/chawyehsu/moonup"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-aarch64-apple-darwin.tar.gz"
      sha256 "14e992d6a3b4bc4570282c77a93b90476124891cddf1081fadee4c029c498bc9"
    else
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-x86_64-apple-darwin.tar.gz"
      sha256 "b0df89de6b62e199e296db1120a66426e3f9501eec07e6d69a0c5c1c3d35dfc5"
    end
  end

  def install
    bin.install "moonup"
    bin.install "moonup-shim"
  end

  test do
    system "#{bin}/moonup", "--version"
  end
end
