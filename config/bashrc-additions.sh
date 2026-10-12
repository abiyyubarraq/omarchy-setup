# ---- omarchy-setup additions (START) ----
# This block is appended to ~/.bashrc by install.sh. Safe to re-run (guarded).

# ble.sh: command suggestions + colors as you type. Loaded first, attached last.
[[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh --attach=none

# Oh My Posh prompt (atomic theme). Neutralize starship so only one prompt runs.
if command -v oh-my-posh &>/dev/null && [[ -f ~/.config/oh-my-posh/atomic.omp.json ]]; then
  starship_precmd() { :; }
  starship_preexec() { :; }
  eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/atomic.omp.json)"
fi

# atuin: better shell history (Ctrl+R). --disable-up-arrow keeps ble.sh's up-arrow.
command -v atuin &>/dev/null && eval "$(atuin init bash --disable-up-arrow)"

# yazi: 'y' opens the file manager and cd's to where you left off
y() {
  local tmp; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  local cwd; cwd="$(cat -- "$tmp")"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# ble.sh must attach last
[[ ${BLE_VERSION-} ]] && ble-attach
# ---- omarchy-setup additions (END) ----
