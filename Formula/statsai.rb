class Statsai < Formula
  desc "Local-first AI usage statistics CLI for macOS."
  homepage "https://statsai.dev"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/starkdmi/statsai/releases/download/v0.7.0/statsai-aarch64-apple-darwin.tar.xz"
      sha256 "22199f575803b87d06c35d680454eac97a93cda039d441d923da2967908c76b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/starkdmi/statsai/releases/download/v0.7.0/statsai-x86_64-apple-darwin.tar.xz"
      sha256 "1188e911a4aa5d407749a9edeabf933a2f934a0594a462e0a2983f3f7d0f8fdb"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "statsai"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "statsai"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
