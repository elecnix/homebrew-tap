# homebrew-tap

Homebrew tap for elecnix's tools:

- **bellwether** (formula), the herdr tools that let one coding agent start and watch child agents, from its npm package.
- **terraform-permcheck** (cask), from its GoReleaser release assets.
- **your-attention** (formula), whose inbox the coding agents ask through.

```sh
brew install elecnix/tap/bellwether
brew install elecnix/tap/terraform-permcheck
brew install elecnix/tap/your-attention
```

## Testing a formula change

Every pull request that touches `Formula/` runs `.github/workflows/formulas.yml` on Linux. The job links the pull request's checkout in as `elecnix/tap`, then runs `brew style`, `brew audit --new --online`, `brew install --build-from-source` and `brew test` on each changed formula. A change to the workflow file tests every formula. `HOMEBREW_NO_AUTO_UPDATE` stays set throughout, so two runs on the same commit test the same thing. Merge a formula change once that job passes.

To try a branch on your own machine first, copy the formula into a scratch tap of its own, and leave the `elecnix/tap` clone where it is:

```sh
export HOMEBREW_NO_AUTO_UPDATE=1
brew tap-new --no-git "$USER/scratch"
cp Formula/bellwether.rb "$(brew --repository "$USER/scratch")/Formula/"
brew install --build-from-source "$USER/scratch/bellwether"
brew test "$USER/scratch/bellwether"
brew uninstall "$USER/scratch/bellwether" && brew untap "$USER/scratch"
```

Uninstall `elecnix/tap/bellwether` before this, because Homebrew installs one formula per name. Keep the installed tap clone on `main`, because every install on the machine reads the branch checked out there. Leave `HOMEBREW_NO_INSTALL_FROM_API` unset too. It makes Homebrew read formulas from a local `homebrew/core` clone of about 1.5 GB instead of the API, and on 2026-11-27 an install under it failed with `No available formula with the name "node"`.

## Releasing bellwether

`npm run release -- <version>` in the bellwether repository opens the formula bump here once npm serves the version. It writes the new `url` and `sha256` on a `bellwether-<version>` branch and merges the pull request once the formulas job passes. Nobody needs to compute a checksum by hand.
