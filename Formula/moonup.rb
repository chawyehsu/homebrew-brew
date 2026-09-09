class Moonup < Formula
  version "0.6.1"
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
      sha256 "1d9bb08c655b348f4d9f3efbe19a5ea839a697a22e80ecb703aa16a42ff5a3b1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b6966a790ce38540c134ace2f5f9727df5c5a3a15c08d0da04c8ca90b29c895f"
    else
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "219177ebd1f29528ead60489742eb7a18193ee60fe80316118f48b93c249bbe8"
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
