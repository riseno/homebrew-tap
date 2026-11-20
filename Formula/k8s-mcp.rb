class K8sMcp < Formula
  desc "Safe, read-only-by-default MCP server for troubleshooting any Kubernetes cluster"
  homepage "https://github.com/riseno/k8s-mcp"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/riseno/k8s-mcp/releases/download/v1.0.1/k8s-mcp-server-aarch64-apple-darwin.tar.gz"
      sha256 "3425cf0a0bc903eeb662a2131876dc8a109416c81270264371325ff6a5e38eae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/riseno/k8s-mcp/releases/download/v1.0.1/k8s-mcp-server-x86_64-apple-darwin.tar.gz"
      sha256 "0caabf8f6fe30cf913518cb46dd094d56280ad1f908d3ac0feb3727d33c86c89"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/riseno/k8s-mcp/releases/download/v1.0.1/k8s-mcp-server-aarch64-unknown-linux-musl.tar.gz"
      sha256 "aa0c6a6e42c4f61d5da03b12365d6a0ba79d5d46e7dc7fecf38103c7a2c00f0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/riseno/k8s-mcp/releases/download/v1.0.1/k8s-mcp-server-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3de594b014d9e67fa3d9069944f5089a7e406014020deeb8ddc6a586cccb9992"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
      bin.install "k8s-mcp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "k8s-mcp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "k8s-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "k8s-mcp"
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
