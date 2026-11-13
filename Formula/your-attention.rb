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

  # Node runs the TypeScript sources directly, so there is no build step: the checkout,
  # its runtime dependencies and a symlink into bin are the whole install. That needs a
  # Node built with type stripping; Homebrew's is.
  def install
    libexec.install Dir["*"]

    cd libexec do
      system "npm", "install", "--omit=dev", "--no-audit", "--no-fund", "--no-save"
    end

    # The pi extension imports typebox at runtime, but package.json lists it under
    # devDependencies (and as a peer), which `--omit=dev` leaves out. Install that one
    # package on its own until upstream moves it to dependencies.
    system "npm", "pack", "typebox@1.4.3", "--pack-destination", buildpath
    (libexec/"node_modules/typebox").mkpath
    system "tar", "xzf", "typebox-1.4.3.tgz", "-C", libexec/"node_modules/typebox", "--strip-components=1"

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
    assert_predicate libexec/"node_modules/typebox/package.json", :exist?
  end
end
