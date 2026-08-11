class Moonup < Formula
  version "0.6.0"
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
      sha256 "8b471cab3a32a25b6d84f48aa58f35aad56d3993351841cdaabbaa1a507d8736"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f61ca8a557c67930027e618695d1d71801c273b796863c166cff1282c0cd6a6b"
    else
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "08bbc8078aebe7e892af32ed3fe69f8b5d3dd911f673702af001cf966c212fda"
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
