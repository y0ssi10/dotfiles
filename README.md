# dotfiles

respect for https://github.com/NagayamaRyoga/dotfiles

## Requirements

- Apple Silicon Mac (aarch64-darwin)
- [Determinate Nix](https://docs.determinate.systems/) (installed automatically by the bootstrap script)

## Bootstrap a new machine

```sh
curl -fsSL https://y0ssi10.github.io/dotfiles/install.sh | bash
```

Or clone manually and run `./install.sh`. You'll be prompted to choose steps:

| key | what it does |
| --- | --- |
| `d` | download this repo to `~/workspace/github.com/y0ssi10/dotfiles` |
| `l` | symlink dotfiles into `$HOME` |
| `s` | run OS-specific app setup (`etc/mac/install.sh`) |
| `i` | install Xcode CLT, Homebrew, Nix |
| `b` | bootstrap nix-darwin (`nix run`) |
| `m` | install mise-managed tool versions |
| `a` | all of the above |

You can combine choices, e.g. `dl`.

## Layout

- `.config/` — XDG-style config files, deployed via home-manager
- `nix/home-manager/` — home-manager configuration (packages, dotfile symlinks)
- `nix/nix-darwin/` — macOS system settings, Homebrew casks/taps
- `nix/apps/` — `nix run` entry point (interactive menu below)
- `etc/mac/`, `scripts/` — pre-Nix bootstrap helpers, kept for initial machine setup

## Day-to-day

```sh
nix run
```

Opens an interactive menu (multi-select) to run any of:

- `darwin-rebuild switch` — apply macOS system + Homebrew changes
- `home-manager switch` — apply dotfile/package changes
- `brew upgrade` — upgrade Homebrew-managed casks/formulae

## Machine-local overrides

Some settings are intentionally left out of this repo and loaded only if present locally:

- `.config/zsh/local.zsh` — machine-specific shell config
- `.config/git/local.config` — git identity (see `.config/git/local.config.sample`); required because `user.useConfigOnly = true` disables git's automatic name/email guessing

## CI

- **Lint** — `nix flake check` (formatting via treefmt/nixfmt)
- **Nix build** — builds `darwinConfigurations.runner` / `homeConfigurations.runner` on every push/PR
- **Deploy Pages** — publishes `install.sh` to GitHub Pages for the bootstrap one-liner above
