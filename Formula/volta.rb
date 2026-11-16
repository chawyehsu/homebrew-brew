class Volta < Formula
  version "2.1.0"
  desc "Volta is a hassle-free way to manage your JavaScript command-line tools (maintained fork)"
  homepage "https://github.com/chawyehsu/volta"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chawyehsu/volta/releases/download/v#{version}/volta-aarch64-apple-darwin.tar.gz"
      sha256 "5dbcfb2de3fe9c8f85ae6d57a114c86ed1ef11e55a14bb6abeadc7f908927207"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chawyehsu/volta/releases/download/v#{version}/volta-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c76d0ce0be66bcbdf65024c759b0fe3aab680e4a9a2807ebe95850b38f1f651b"
    else
      url "https://github.com/chawyehsu/volta/releases/download/v#{version}/volta-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eae48ba833369ffff853749123d62a561f06b6ed5d0217844bc6b64fa776ecac"
    end
  end

  def install
    bin.install "volta"
    bin.install "volta-migrate"
    bin.install "volta-shim"
  end

  test do
    system "#{bin}/volta", "--version"
  end
end
