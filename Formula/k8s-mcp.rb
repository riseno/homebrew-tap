class K8sMcp < Formula
  desc "Safe, read-only-by-default MCP server for troubleshooting any Kubernetes cluster"
  homepage "https://github.com/riseno/k8s-mcp"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.3.1/k8s-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "7d5c93c264350e318714edab8e26084a17dc9e43f348ddab3fb8da339efb88ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.3.1/k8s-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "3fb63d6dfa513adcc28b7e73a2743b0049f5f00ed7631bf84717930e70aeb288"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.3.1/k8s-mcp-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f7279ea52e6294f696e7bbd238784df095c36b9a5c8faeebf9a1a4fcfd49df38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.3.1/k8s-mcp-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "cef0a9424141e055b9cc1e8dd57f3bfad629d349f60705f8da401afe25dc4ea4"
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
