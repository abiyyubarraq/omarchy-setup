# CLI Tools — what they are & how to use them

Press `q` to quit this view. Arrow keys / `Space` to scroll.

---

## Move around & files

| Tool | What it is | Try this |
|---|---|---|
| `z` | Jump to any folder you visited before (zoxide) | `z proj` |
| `y` | File manager with previews (yazi). Terminal follows where you go | `y` |
| `eza` | Prettier `ls` with icons | `eza -la --icons` · tree: `eza --tree --level=2` |
| `bat` | `cat` with colors + line numbers | `bat file.txt` |
| `fd` | Fast file finder (simpler `find`) | `fd report` · only .md: `fd -e md` |
| `dust` | Which folders eat the most space | `dust` (run inside a folder) |
| `duf` | Disk free space, clean table | `duf` |

## Search

| Tool | What it is | Try this |
|---|---|---|
| `rg` | Super-fast text search (ripgrep) | `rg "TODO"` · in .ts only: `rg -t ts "function"` |
| `fzf` | Fuzzy picker for anything | `vim $(fzf)` |
| `Ctrl+R` | Searchable shell history (atuin) | press `Ctrl+R`, type part of an old command |

## Git

| Tool | What it is | Try this |
|---|---|---|
| `lazygit` | Full git in a terminal UI (stage, commit, branches) | `lazygit` |
| `delta` | Colored side-by-side diffs (automatic) | `git diff` · `git log -p` |

## System & Docker

| Tool | What it is | Try this |
|---|---|---|
| `btop` | Task manager — CPU, RAM, processes (also `Super+Ctrl+T`) | `btop` |
| `lazydocker` | Docker containers/images/logs in a UI | `lazydocker` |

## Notes & data

| Tool | What it is | Try this |
|---|---|---|
| `glow` | Render Markdown nicely | `glow README.md` |
| `jq` | Read/filter JSON | `cat file.json \| jq '.key'` |
| `yq` | Same as jq but for YAML | `yq '.services' docker-compose.yml` |
| `tldr` | Short examples for any command | `tldr tar` · `tldr ffmpeg` |

---

### Handy keys (desktop)

| Key | Does |
|---|---|
| `Super + Enter` | Terminal (opens in ~/tmp) |
| `Super + Space` | App launcher |
| `Super + N` | Quick note |
| `Super + Ctrl + T` | Activity (btop) |
| `Super + Ctrl + Shift + K` | On-screen keyboard |

_Edit this file: `~/.config/omarchy/cli-tools.md`_
