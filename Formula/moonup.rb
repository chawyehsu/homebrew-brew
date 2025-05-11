class Moonup < Formula
  version "0.2.3"
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
      sha256 "15fa8b19fbd516e9c03d0c97172f261e15f7a10bbe0ebfee2449fa8a6d40c0e0"
    else
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-x86_64-apple-darwin.tar.gz"
      sha256 "35602416a7b65a182b8f5ac4b10dff2d82e09e6d4abd6aa71a39f70b388c3cd7"
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
