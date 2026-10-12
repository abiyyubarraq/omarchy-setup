# omarchy-setup

My curated [Omarchy](https://omarchy.org) desktop + developer setup, as a one-command install for a fresh machine.

It adds handy terminal tools, a nicer prompt, quality-of-life keybindings, launcher shortcuts, and file-manager tweaks — on top of a stock Omarchy install. Nothing personal or secret is included.

## Quick start

On a fresh Omarchy machine:

```bash
git clone https://github.com/<your-user>/omarchy-setup.git ~/omarchy-setup
cd ~/omarchy-setup
./install.sh
```

It asks for your password once (sudo) and is safe to re-run. When it finishes, **open a new terminal** (`Super + Enter`) to load the new prompt, suggestions and history.

## What it sets up

| Area | What you get |
|---|---|
| **Terminal tools** | `atuin` (great `Ctrl+R` history), `yazi` (file manager + previews, run `y`), `delta` (pretty git diffs), `glow` (Markdown), `duf`/`dust` (disk), `yq`, plus `rg fd fzf eza bat lazygit lazydocker btop tldr` |
| **Prompt** | Oh My Posh (atomic theme) + `ble.sh` for inline command suggestions and colors |
| **Languages** | mise installs node, bun, deno, python, go, java, uv, oh-my-posh |
| **Keybindings** | `Super+N` quick note · `Super+Enter` opens terminal in `~/tmp` · close lid → sleep · `Super+Ctrl+Shift+K` on-screen keyboard · `Super+F`/`Super+Alt+F` swapped (full-width / full-screen) |
| **Launcher** (`Super+Space`) | **Activity** (btop), **CLI Tools** (a scrollable cheat sheet of every tool), **WiFi Login** (fixes captive-portal pages that don't show), **Notes AI** (opens Claude Code in your notes folder) |
| **Files (Nautilus)** | right-click → **Open in Terminal** (foot) and **Copy Path** |
| **Defaults** | Chrome as browser, `.md` → VS Code, `.txt` → Text Editor (keeps unsaved text like Windows Notepad) |

## Layout

```
install.sh            one-command installer (idempotent)
config/
  hypr-bindings.lua   keybinding customizations (appended to your bindings.lua)
  bashrc-additions.sh shell setup (appended to ~/.bashrc)
  atomic.omp.json     Oh My Posh theme
  cli-tools.md        the CLI cheat sheet
  menu-entries.jsonc  launcher entries
bin/                  launcher scripts → ~/.local/bin
nautilus/             right-click extensions → Files
```

## Notes & manual steps

Some things can't be scripted and are up to you after install:

- **Logins** (per machine): `gh auth login`, `gcloud auth login`, browser sign-ins, VS Code Settings Sync.
- **On-screen keyboard**: `yay -S wvkbd` (if your network blocks SourceHut, build it from the GitHub mirror `github.com/jjsullivan5196/wvkbd`). Then `Super+Ctrl+Shift+K`.
- **Notes AI** opens Claude Code in `~/Documents/Notes` (set `NOTES_DIR` to change). It needs Claude Code installed and logged in: `curl -fsSL https://claude.ai/install.sh | bash`.
- **Dual-boot clock** (if you also run Windows): `timedatectl set-local-rtc 1` so both OSes agree on the time.

## Undo

Every file the installer changes is backed up next to it (`*.bak.<timestamp>`): `~/.bashrc`, `~/.config/hypr/bindings.lua`, and the launcher menu. Remove the appended blocks or restore a backup to revert.

## License

MIT — use freely.
