class K8sMcp < Formula
  desc "Safe, read-only-by-default MCP server for troubleshooting any Kubernetes cluster"
  homepage "https://github.com/riseno/k8s-mcp"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.2.0/k8s-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "61c6e3e6c8b4eaf3946b0f1debbdd080a58bd6e56d6f31a476f4754267a792a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.2.0/k8s-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "2a719f2710471bd29ab5ceee5cd798e87a6b0ee066700e97f35f4fdb290e6649"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.2.0/k8s-mcp-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ae7331879dd807c5e5abd8fec24ca9769cefb20f2800d857d370e5e65e0443d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.2.0/k8s-mcp-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5489767cfdbcac1ff02784d5867f6ecf63b4ad9605e60de27116f74a0533dd6b"
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
