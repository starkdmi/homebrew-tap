class Statsai < Formula
  desc "Local-first AI usage statistics CLI for macOS."
  homepage "https://statsai.dev"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/starkdmi/statsai/releases/download/v0.3.1/statsai-aarch64-apple-darwin.tar.xz"
      sha256 "0f9707b40df5ceaad889f8a8699cf56d25d0543d4f0b78a36f964631e0e3b200"
    end
    if Hardware::CPU.intel?
      url "https://github.com/starkdmi/statsai/releases/download/v0.3.1/statsai-x86_64-apple-darwin.tar.xz"
      sha256 "0d4c8a145f8620dbe1ed7db533f2a6f2feafa1c87370d2bba26017764c894eda"
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
