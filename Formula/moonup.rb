class Moonup < Formula
  version "0.3.1"
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
      sha256 "addd82bc27ac037beef3a08b56ffb3a3c75e21adc5c9952b70f9747868ac147e"
    else
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-x86_64-apple-darwin.tar.gz"
      sha256 "50f01a01cb5caa84d604c3b0c182032b2f7e3c282fac08be46989497eaaaab7d"
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
