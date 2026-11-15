class K8sMcp < Formula
  desc "Safe, read-only-by-default MCP server for troubleshooting any Kubernetes cluster"
  homepage "https://github.com/riseno/k8s-mcp"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.1.0/k8s-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "94742bafdf1eccd26932ab401db96974a41cfe62b52c7e4f3d16ce92b1d22365"
    end
    if Hardware::CPU.intel?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.1.0/k8s-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "ac2a993dbb81214583ef105a2eae0fa5617d33f44280a6693337e34991f8846d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.1.0/k8s-mcp-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "e89088d3f5f15f9e3b89f7006596ae2b99732183fe91ccb56a17e8466588949d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.1.0/k8s-mcp-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "009378db17fa20d19d8773a2d866afc58f579bd6d595dbbf7a987ff2706a0ce6"
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
