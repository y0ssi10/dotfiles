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
| `i` | install Xcode CLT, Homebrew, Nix |
| `b` | bootstrap nix-darwin (`nix run`) |
| `m` | install mise-managed tool versions |
| `a` | download and symlink dotfiles (`d` + `l`) |

You can combine choices, e.g. `dl`.

Applications are managed by Home Manager and nix-darwin. Use `i` to install
prerequisites and `b` to apply the Nix configuration; the old `s` option is removed.

## Layout

- `.config/` — XDG-style config files, deployed via home-manager
- `nix/home-manager/` — home-manager configuration (packages, dotfile symlinks)
- `nix/nix-darwin/` — macOS system settings, Homebrew casks/taps
- `nix/apps/` — `nix run` entry point (interactive menu below)
- `install.sh` — initial machine setup and Nix bootstrap

## Day-to-day

```sh
nix run
```

Opens an interactive menu (multi-select) to run any of:

- `darwin-rebuild switch` — apply macOS system + Homebrew changes
- `home-manager switch` — apply dotfile/package changes
- `brew upgrade` — upgrade Homebrew-managed casks/formulae

## Rex and repositories

Install Rex for macOS separately and enable **Remote Control** in its settings
to allow the CLI to select sessions. The shell prioritizes `REX_BIN_DIR`, then
the current server's CLI and the CLI bundled in `/Applications/Rex Beta.app`.
Existing directories are added to `PATH` even outside Rex or when
`REX_BIN_DIR` is unset.

- `Ctrl+G` in Rex: choose a repository with ghq + fzf in a floating terminal,
  then open a fresh Rex tab in
  that directory. The session label is the repository's final path component
  (e.g. `dotfiles`). An existing session is reused; otherwise a session with
  its first tab is created. Repositories with the same name share a session.
  Rex selects the new tab; the invoking shell's directory and pending input
  remain unchanged.
- `Alt+G`: choose a repository and `cd` in the current shell.
- Existing Rex sessions are marked in the repository picker.
- `Cmd+G`: open lazygit in a floating terminal in the current directory.

The picker is a Rex action (`ghq_open`), also available in the command palette.
Its floating picker calls the same action with the selection; the action creates
the tab and queues the UI switch for the invoking client. Cancelling returns focus
to the original terminal. It is implemented in `.config/rex/plugins/ghq`;
Zsh's directory widget only handles `Alt+G`.
Rex's Option key must send Alt for that shell shortcut.

Home Manager links `.config/rex/init.lua` and `.config/rex/plugins`. Run `rex config check` and
`rex config reload` after applying it. The old `.config/herdr/config.toml`
is retained as a migration reference, but is no longer deployed.

## Machine-local overrides

Some settings are intentionally left out of this repo and loaded only if present locally:

- `.config/zsh/local.zsh` — machine-specific shell config
- `.config/git/local.config` — git identity (see `.config/git/local.config.sample`); required because `user.useConfigOnly = true` disables git's automatic name/email guessing

## CI

- **Lint** — `nix flake check` (formatting via treefmt/nixfmt)
- **Nix build** — builds `darwinConfigurations.runner` / `homeConfigurations.runner` on every push/PR
- **Deploy Pages** — publishes `install.sh` to GitHub Pages for the bootstrap one-liner above
