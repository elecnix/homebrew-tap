class YourAttention < Formula
  desc "One inbox for the questions all your coding agents ask you"
  homepage "https://github.com/elecnix/your-attention"
  # The project publishes no tag, release asset or npm package yet, so this pins a
  # commit. `livecheck` cannot follow a commit: a new commit means a new url and a new
  # sha256 here, by hand.
  url "https://github.com/elecnix/your-attention/archive/01580d471ab1e9b66a71b83b5fdfe56462291c07.tar.gz"
  version "0.1.0"
  sha256 "2316a38f14397ab64593a6cf990f78381f7f4fef2fdbc12ef937e34809f21b2c"
  license "MIT"

  depends_on "node"

  # Node runs the TypeScript sources directly, so there is no build step: the checkout, its
  # runtime dependencies and a symlink into bin are the whole install. That needs a Node
  # built with type stripping; Homebrew's is. The pi extension imports typebox, which
  # package.json lists under devDependencies, but pi ships typebox itself and loads the
  # extension, so the CLI does not need it here.
  def install
    libexec.install Dir["*"]

    cd libexec do
      system "npm", "install", "--omit=dev", "--no-audit", "--no-fund", "--no-save"
    end

    bin.install_symlink libexec/"bin/your-attention.js" => "your-attention"
  end

  service do
    run [opt_bin/"your-attention", "serve"]
    keep_alive true
    log_path var/"log/your-attention.log"
    error_log_path var/"log/your-attention.log"
  end

  # The command has no --version flag: with no argument it prints its own list.
  test do
    assert_match "one inbox for the questions", shell_output("#{bin}/your-attention")
    assert_predicate libexec/"src/cli.ts", :exist?
  end
end
