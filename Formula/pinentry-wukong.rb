class PinentryWukong < Formula
  version "0.1.3"
  desc "A versatile pinentry implementation written in Rust"
  homepage "https://github.com/chawyehsu/pinentry-wukong"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chawyehsu/pinentry-wukong/releases/download/v#{version}/pinentry-wukong-aarch64-apple-darwin.tar.gz"
      sha256 "244dedb0fc5f99b2ec9c41a681a977df528fb642d3f313131915ba26b7c556a3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chawyehsu/pinentry-wukong/releases/download/v#{version}/pinentry-wukong-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c675fce3c0d8e146c97b086a6345cb35e2c841892be0fb858d9b02f8cde499a4"
    else
      url "https://github.com/chawyehsu/pinentry-wukong/releases/download/v#{version}/pinentry-wukong-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "47799203dd2119c16f785256b7da77503662b7da36eff43d63a0c0985469c7d3"
    end
  end

  def install
    bin.install "pinentry-wukong"
  end

  test do
    system "#{bin}/pinentry-wukong", "--version"
  end
end
