# Dotfiles

Minimal dotfiles for devcontainers. Installs my personal
[.agents](https://github.com/JRedOW/.agents) hub and wires its harness links
and profile aliases into the container home directory.

## What it does

`install.sh`:

1. Clones `https://github.com/JRedOW/.agents.git` to `~/.agents` if it is not
   already a git checkout.
2. Ensures `jq` is available. On apt-based images it installs `jq` with
   `apt-get` when missing.
3. Runs `~/.agents/scripts/link.sh` to link skills, agents, commands, and
   harness config into `~/.claude` and `~/.config/opencode`.
4. Adds a marked source block to `~/.bashrc` and `~/.zshrc` for the
   `claude-<profile>` and `opencode-<profile>` aliases from
   `~/.agents/scripts/profiles.sh`.

The script is idempotent. An existing `~/.agents` checkout is left alone.

## Local setup

```bash
git clone https://github.com/JRedOW/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

Restart your shell, or run `source ~/.bashrc` / `source ~/.zshrc`, to pick up
the aliases.

## Dev containers

VS Code user settings:

```json
{
  "dotfiles.repository": "JRedOW/dotfiles",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

Dev Container CLI:

```bash
devcontainer up --workspace-folder . \
  --dotfiles-repository https://github.com/JRedOW/dotfiles.git \
  --dotfiles-install-command install.sh
```

The dotfiles repo is cloned to `~/dotfiles`; `install.sh` clones `.agents`
separately to `~/.agents`.
