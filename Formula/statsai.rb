class Statsai < Formula
  desc "Local-first AI usage statistics CLI for macOS."
  homepage "https://statsai.dev"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/starkdmi/statsai/releases/download/v0.4.0/statsai-aarch64-apple-darwin.tar.xz"
      sha256 "faca7eaa7fd180dc77f2dead1c303302c7f20ef9dbb7ff6a7db660b339bc98b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/starkdmi/statsai/releases/download/v0.4.0/statsai-x86_64-apple-darwin.tar.xz"
      sha256 "6ef7e402083f57ba1dda3a4114d19d78e89ece878cca8a0cbd6a3c5071d0a693"
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
