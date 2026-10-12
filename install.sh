#!/usr/bin/env bash
# omarchy-setup — recreate a curated Omarchy desktop + dev setup on a fresh machine.
# Run it on a freshly installed Omarchy system:
#     git clone <this repo> ~/omarchy-setup && cd ~/omarchy-setup && ./install.sh
#
# It is safe to re-run (idempotent). It asks for your password once (sudo).
# Nothing here is destructive except the optional "remove bloat" step, which asks first.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
say() { printf "\n\033[1;36m==> %s\033[0m\n" "$*"; }
ok()  { printf "   \033[32m✓\033[0m %s\n" "$*"; }
warn(){ printf "   \033[33m!\033[0m %s\n" "$*"; }

if ! command -v omarchy >/dev/null 2>&1; then
  warn "This does not look like an Omarchy system. Continue anyway? (Ctrl+C to stop)"; sleep 3
fi

# ---------------------------------------------------------------------------
say "1/12  Official packages (pacman)"
# CLI tools + apps. Edit this list to taste.
sudo pacman -S --needed --noconfirm \
  atuin yazi git-delta glow duf dust yq \
  ripgrep fd jq fzf zoxide eza bat tldr lazygit lazydocker btop \
  7zip unzip wl-clipboard \
  firefox vlc mpv \
  snapshot gnome-text-editor \
  git-lfs nautilus-python \
  && ok "pacman packages installed"
git lfs install >/dev/null 2>&1 || true

# ---------------------------------------------------------------------------
say "2/12  AUR packages (optional: browsers, VS Code, gcloud)"
if command -v yay >/dev/null 2>&1; then
  read -rp "   Install google-chrome, brave-bin, visual-studio-code-bin? [y/N] " a
  [[ "$a" =~ ^[yY]$ ]] && yay -S --needed --noconfirm google-chrome brave-bin visual-studio-code-bin && ok "AUR browsers/editor installed"
else
  warn "yay not found; skipping AUR apps"
fi

# ---------------------------------------------------------------------------
say "3/12  Language runtimes (mise)"
if command -v mise >/dev/null 2>&1; then
  mise use -g node@22 bun deno python@3.13 go@1.24 java@24 uv oh-my-posh 2>&1 | tail -1
  mise reshim 2>/dev/null
  ok "mise tools installed (node, bun, deno, python, go, java, uv, oh-my-posh)"
else
  warn "mise not found; skipping runtimes"
fi

# ---------------------------------------------------------------------------
say "4/12  ble.sh (command suggestions + colors in bash)"
if [[ ! -f ~/.local/share/blesh/ble.sh ]]; then
  tmp="$(mktemp -d)"
  if git clone -q --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git "$tmp/ble.sh"; then
    make -C "$tmp/ble.sh" install PREFIX=~/.local >/dev/null 2>&1 && ok "ble.sh installed"
  else
    warn "could not fetch ble.sh (network); skip"
  fi
  rm -rf "$tmp"
else
  ok "ble.sh already installed"
fi

# ---------------------------------------------------------------------------
say "5/12  Prompt theme (Oh My Posh, atomic)"
mkdir -p ~/.config/oh-my-posh
cp "$HERE/config/atomic.omp.json" ~/.config/oh-my-posh/ && ok "atomic theme installed"

# ---------------------------------------------------------------------------
say "6/12  Shell additions (~/.bashrc)"
MARK="# ---- omarchy-setup additions (START) ----"
if ! grep -qF "$MARK" ~/.bashrc 2>/dev/null; then
  cp ~/.bashrc ~/.bashrc.bak.$(date +%s) 2>/dev/null
  printf "\n" >> ~/.bashrc
  cat "$HERE/config/bashrc-additions.sh" >> ~/.bashrc
  ok "appended shell setup (ble.sh, oh-my-posh, atuin, yazi)"
else
  ok "shell additions already present"
fi

# ---------------------------------------------------------------------------
say "7/12  git: delta diffs + sane defaults"
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global merge.conflictStyle "zdiff3"
git config --global core.autocrlf input
ok "git configured for delta"

# ---------------------------------------------------------------------------
say "8/12  Launcher scripts (~/.local/bin)"
mkdir -p ~/.local/bin
cp "$HERE"/bin/* ~/.local/bin/ && chmod +x ~/.local/bin/{omarchy-terminal-tmp,cli-tools,wifi-login,notes-ai}
cp "$HERE/config/cli-tools.md" ~/.config/omarchy/cli-tools.md 2>/dev/null
ok "installed: omarchy-terminal-tmp, cli-tools, wifi-login, notes-ai"

# ---------------------------------------------------------------------------
say "9/12  Files (Nautilus) right-click: Open in Terminal + Copy Path"
mkdir -p ~/.local/share/nautilus-python/extensions
cp "$HERE"/nautilus/*.py ~/.local/share/nautilus-python/extensions/ && ok "nautilus extensions installed (restart Files)"

# ---------------------------------------------------------------------------
say "10/12  Launcher menu entries (Activity, CLI Tools, WiFi Login, Notes AI)"
EXT=~/.config/omarchy/extensions/omarchy-menu.jsonc
mkdir -p "$(dirname "$EXT")"
[[ -f "$EXT" ]] || printf '{\n}\n' > "$EXT"
python3 - "$EXT" "$HERE/config/menu-entries.jsonc" <<'PY'
import sys, re, json
ext, add = sys.argv[1], sys.argv[2]
def strip(t): return re.sub(r'//[^\n]*','',t)
cur = strip(open(ext).read()).strip() or "{}"
try: cur = json.loads(cur)
except Exception: cur = {}
new = json.loads(strip(open(add).read()))
cur.update(new)
open(ext,"w").write(json.dumps(cur, ensure_ascii=False, indent=2)+"\n")
print("merged", len(new), "entries")
PY
omarchy menu refresh 2>/dev/null || true
ok "menu entries added"

# ---------------------------------------------------------------------------
say "11/12  Keybindings (~/.config/hypr/bindings.lua)"
BIND=~/.config/hypr/bindings.lua
if [[ -f "$BIND" ]] && ! grep -q "omarchy-setup keybinding customizations" "$BIND"; then
  cp "$BIND" "$BIND.bak.$(date +%s)"
  printf "\n" >> "$BIND"
  cat "$HERE/config/hypr-bindings.lua" >> "$BIND"
  hyprctl reload >/dev/null 2>&1 || true
  ok "keybindings added (OSK, F-swap, Super+Enter→tmp, Super+N note, lid suspend)"
else
  ok "keybindings already present or bindings.lua missing"
fi

# ---------------------------------------------------------------------------
say "12/12  Default apps"
command -v google-chrome-stable >/dev/null && { env -u BROWSER xdg-settings set default-web-browser google-chrome.desktop 2>/dev/null; ok "Chrome = default browser"; }
[[ -f /usr/share/applications/com.microsoft.VSCode.desktop ]] && xdg-mime default com.microsoft.VSCode.desktop text/markdown && ok ".md opens in VS Code"
xdg-mime default org.gnome.TextEditor.desktop text/plain 2>/dev/null && ok ".txt opens in Text Editor"

# ---------------------------------------------------------------------------
say "Done!"
cat <<'EOF'
   Open a NEW terminal (Super+Enter) to load the prompt, suggestions and history.
   Restart Files to get the right-click menu items.
   Optional on-screen keyboard: yay -S wvkbd  (then Super+Ctrl+Shift+K)

   What you got:
     • Tools: atuin, yazi, delta, glow, duf, dust, yq, + the usual (rg, fd, fzf, eza, bat, lazygit…)
     • Prompt: Oh My Posh (atomic) + ble.sh suggestions
     • Keys: Super+N note, Super+Enter→~/tmp, lid-close sleep, Super+Ctrl+Shift+K on-screen keyboard
     • Launcher: Activity, CLI Tools (cheat sheet), WiFi Login, Notes AI
     • Files: right-click Open in Terminal + Copy Path
EOF
