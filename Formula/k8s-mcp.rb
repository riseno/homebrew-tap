class K8sMcp < Formula
  desc "Safe, read-only-by-default MCP server for troubleshooting any Kubernetes cluster"
  homepage "https://github.com/riseno/k8s-mcp"
  version "0.1.0-rc.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.1.0-rc.3/k8s-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "2f17d87f3928d5cee9f80a4b23f1b94af39a0a7f2a6b3948b1f251c758c56809"
    end
    if Hardware::CPU.intel?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.1.0-rc.3/k8s-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "1498923b91ffd4cbea82d763ba41de9fce41b2db0fb9f9f995c05a5ba1db3897"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.1.0-rc.3/k8s-mcp-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9e43450fbe8de34ac77637c082ef9b686c38d77796cdfcd65edc6ef39c5d33cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/riseno/k8s-mcp/releases/download/v0.1.0-rc.3/k8s-mcp-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "17f1b588f81d213bacda672ae9736a552077ed59781b0f857a462103deb21bb1"
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
