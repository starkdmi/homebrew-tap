class Statsai < Formula
  desc "Local-first AI usage statistics CLI for macOS."
  homepage "https://statsai.dev"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/starkdmi/statsai/releases/download/v0.8.0/statsai-aarch64-apple-darwin.tar.xz"
      sha256 "dcb30e3675e67ea7948ca869587e276fb99e8f77e7e95da925b5710bbbafabc0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/starkdmi/statsai/releases/download/v0.8.0/statsai-x86_64-apple-darwin.tar.xz"
      sha256 "fa98aee3542f57dd1d92afb3e91c4c6a99096a91c574de0044e41b751977b490"
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
