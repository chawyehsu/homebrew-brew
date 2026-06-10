class Moonup < Formula
  version "0.5.2"
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
      sha256 "5f4a95e8a0351c894987943950cc0c635fbb0888d381cb74e4ee6723986dce78"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c742637f11840dde39a69edac217623fe0a7095d93435da54a2b705d4552b631"
    else
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f00df7aa43f7f5706f9114040eef2abde9ff1774f10a3a69487dcec0f10b5ae0"
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
