#!/usr/bin/env bash
set -euo pipefail

test_home=$(mktemp -d)
trap 'rm -rf "$test_home"' EXIT
mkdir -p "$test_home/.config/Code/CachedExtensionVSIXs/.trash" \
  "$test_home/.local/share/Steam/package/tmp" \
  "$test_home/.local/share/cursor-agent/versions/old" \
  "$test_home/.local/share/cursor-agent/versions/current" \
  "$test_home/.local/bin" \
  "$test_home/.vscode/extensions/example/node_modules"
touch "$test_home/.config/Code/CachedExtensionVSIXs/.trash/download" \
  "$test_home/.local/share/Steam/package/tmp/update" \
  "$test_home/.local/bin/Cursor-old.AppImage.zs-old" \
  "$test_home/.local/bin/agy.123.old" \
  "$test_home/.local/share/cursor-agent/versions/old/cursor-agent" \
  "$test_home/.local/share/cursor-agent/versions/current/cursor-agent" \
  "$test_home/.vscode/extensions/example/node_modules/dependency"
chmod +x "$test_home/.local/share/cursor-agent/versions/current/cursor-agent"
ln -s "$test_home/.local/share/cursor-agent/versions/current/cursor-agent" \
  "$test_home/.local/bin/cursor-agent"

HOME="$test_home" bash "$(dirname "$0")/LinuxCleaner_42.sh" --dry-run >/dev/null
test -e "$test_home/.config/Code/CachedExtensionVSIXs/.trash/download"
test -e "$test_home/.local/share/Steam/package/tmp/update"
test -e "$test_home/.local/share/cursor-agent/versions/old/cursor-agent"

HOME="$test_home" bash "$(dirname "$0")/LinuxCleaner_42.sh" >/dev/null
test ! -e "$test_home/.config/Code/CachedExtensionVSIXs/.trash"
test ! -e "$test_home/.local/share/Steam/package/tmp"
test ! -e "$test_home/.local/bin/Cursor-old.AppImage.zs-old"
test ! -e "$test_home/.local/bin/agy.123.old"
test ! -e "$test_home/.local/share/cursor-agent/versions/old"
test -e "$test_home/.local/share/cursor-agent/versions/current/cursor-agent"
test -e "$test_home/.vscode/extensions/example/node_modules/dependency"
