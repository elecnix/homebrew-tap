class YourAttention < Formula
  desc "One inbox for the questions all your coding agents ask you"
  homepage "https://github.com/elecnix/your-attention"
  url "https://github.com/elecnix/your-attention/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d508dc36c16a09e4c70dbad5931eaf948b0dec5691c1c05f7c0341318ff8b6d7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "node"

  # Node runs the TypeScript sources directly, so there is no build step: the checkout,
  # its runtime dependencies and a symlink into bin are the whole install. That needs a
  # Node built with type stripping; Homebrew's is. The pi extension imports typebox,
  # which package.json lists under devDependencies, but pi ships typebox itself and loads
  # the extension there, so the CLI does not need it here.
  def install
    libexec.install Dir["*"]
    cd libexec do
      system "npm", "install", *std_npm_args(prefix: false), "--omit=dev"
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
    assert_match "one inbox for the questions", shell_output(bin/"your-attention")
    assert_path_exists libexec/"src/cli.ts"
  end
end
