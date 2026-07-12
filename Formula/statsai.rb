class Statsai < Formula
  desc "Local-first AI usage statistics CLI for macOS."
  homepage "https://statsai.dev"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/starkdmi/statsai/releases/download/v0.3.2/statsai-aarch64-apple-darwin.tar.xz"
      sha256 "96b8c3fa5a8710c7ba46d8be177c05e1dca01592d5a27f75545f1a6c856e51f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/starkdmi/statsai/releases/download/v0.3.2/statsai-x86_64-apple-darwin.tar.xz"
      sha256 "ae98f83774532f9f44b2208064969311637db7357ba6810cda328dc103d3c83c"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "statsai" if OS.mac? && Hardware::CPU.arm?
    bin.install "statsai" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
