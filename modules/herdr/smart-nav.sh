#!/bin/sh
# Vim-aware pane navigation for herdr, bound to bare ctrl+h/j/k/l via
# [[keys.command]] in config.toml. Mirrors tmux's vim-tmux-navigator
# is_vim trick, which herdr has no built-in equivalent for: if the pane
# that had focus when the key was pressed is running nvim, forward the
# raw keystroke into it (nvim's own smart-splits.nvim keymap + the custom
# herdr mux backend then handle intra-nvim splits and edge fallback).
# Otherwise, ask herdr to switch panes directly.
set -eu

direction="${1:-}"
pane="${HERDR_ACTIVE_PANE_ID:-}"
[ -n "$pane" ] && [ -n "$direction" ] || exit 0

case "$direction" in
  left) key="ctrl+h" ;;
  down) key="ctrl+j" ;;
  up) key="ctrl+k" ;;
  right) key="ctrl+l" ;;
  *) exit 1 ;;
esac

info=$(herdr pane process-info --pane "$pane" 2>/dev/null) || exit 0

case "$info" in
  *'"argv0":"nvim"'*)
    herdr pane send-keys "$pane" "$key" >/dev/null 2>&1
    ;;
  *)
    herdr pane focus --pane "$pane" --direction "$direction" >/dev/null 2>&1
    ;;
esac
