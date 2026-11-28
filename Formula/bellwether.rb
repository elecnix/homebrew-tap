class Bellwether < Formula
  desc "Herdr tools that let one coding agent start and watch child agents"
  homepage "https://github.com/elecnix/bellwether"
  url "https://registry.npmjs.org/@elecnix/bellwether/-/bellwether-0.1.10.tgz"
  sha256 "111655013286aff13f34ce6fa850f0efbdd1a567371847781a55f5d99134c463"
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

  # The test reads no message text, so rewording help or doctor never breaks it.
  # Printing help loads the CLI's whole module graph, which fails on a missing
  # runtime dependency; the version check proves the tarball is the one named above.
  test do
    package = libexec/"lib/node_modules/@elecnix/bellwether"
    assert_equal version.to_s, JSON.parse((package/"package.json").read)["version"]
    system bin/"bellwether", "help"
    assert_predicate bin/"bellwether-mcp", :executable?
  end
end
