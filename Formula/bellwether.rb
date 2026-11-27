class Bellwether < Formula
  desc "Herdr tools that let one coding agent start and watch child agents"
  homepage "https://github.com/elecnix/bellwether"
  url "https://registry.npmjs.org/@elecnix/bellwether/-/bellwether-0.1.3.tgz"
  sha256 "e5f963a447ffa01ceabdf69b9c9810109a8b69f1047df063673f90b6c89d0a6a"
  license "MIT"

  livecheck do
    url :stable
    strategy :npm
  end

  # package.json declares engines.node >=22.18; Homebrew's node is newer than that.
  depends_on "node"

  # The npm tarball already holds the compiled dist/, so npm only fetches the one
  # runtime dependency. Both bins go on PATH: bellwether is the CLI, and
  # bellwether-mcp is the stdio MCP server that Claude Code starts by name.
  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/bellwether"
    bin.install_symlink libexec/"bin/bellwether-mcp"
  end

  # The command has no --version flag: help prints its usage. doctor checks that the
  # pi extension and the MCP entry exist in the installed package, then fails on the
  # herdr socket, which a test sandbox never has.
  test do
    assert_match "Usage: bellwether", shell_output("#{bin}/bellwether help")

    ENV["BELLWETHER_HOME"] = testpath/"bellwether"
    ENV["HERDR_SOCKET_PATH"] = testpath/"herdr.sock"
    output = shell_output("#{bin}/bellwether doctor", 1)
    assert_match "ok    pi extension", output
    assert_match "ok    mcp entry", output
    assert_match "herdr socket: #{testpath}/herdr.sock does not exist", output
    assert_predicate bin/"bellwether-mcp", :executable?
  end
end
