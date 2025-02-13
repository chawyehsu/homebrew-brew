class Moonup < Formula
  version "0.2.2"
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
      sha256 "6b64a2c26b771b68bf56acb985e059069fb5f0f0d853c833b62c98e21dc1be01"
    else
      url "https://github.com/chawyehsu/moonup/releases/download/v#{version}/moonup-x86_64-apple-darwin.tar.gz"
      sha256 "c5b1d8f5699cdec43c37bc93dfd964aadcabd9b52f72032e98dff89950d60b24"
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
