class Moonup < Formula
  version "0.4.3"
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
      sha256 "2266e4c90d26b351e7bb78dbfbdca1fcf2314e4e648248ab33676112e5b7bd78"
    else
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-x86_64-apple-darwin.tar.gz"
      sha256 "068b58674e1e9de03305ce10460a97be76e7cd509e0412b3d39c44aba26d6584"
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
