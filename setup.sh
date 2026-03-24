#!/bin/bash
# Ghostty + Claude Code full setup script
# Based on: BravoHenry's Ghostty终端配置指南 + Steipete's statusline
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Ghostty + Claude Code Setup ==="
echo ""

# 1. Font
echo "[1/4] Installing Maple Mono NF CN font..."
if brew list --cask font-maple-mono-nf-cn &>/dev/null; then
  echo "  Already installed, skipping."
else
  brew install --cask font-maple-mono-nf-cn
fi
echo ""

# 2. Yazi
echo "[2/4] Installing yazi (terminal file manager)..."
if command -v yazi &>/dev/null; then
  echo "  Already installed ($(yazi --version 2>/dev/null || echo 'installed'))."
else
  brew install yazi
fi
echo ""

# 3. Ghostty config
echo "[3/4] Installing Ghostty config..."
mkdir -p ~/.config/ghostty
if [ -f ~/.config/ghostty/config ]; then
  echo "  Existing config found — backing up to ~/.config/ghostty/config.bak"
  cp ~/.config/ghostty/config ~/.config/ghostty/config.bak
fi
cp "$SCRIPT_DIR/config.ghostty" ~/.config/ghostty/config
echo "  Installed to ~/.config/ghostty/config"
echo ""

# 4. Claude Code statusline
echo "[4/4] Installing Claude Code statusline..."
TARGET="$HOME/.claude/statusline-worktree.js"
cp "$SCRIPT_DIR/statusline-worktree.js" "$TARGET"
chmod +x "$TARGET"
echo "  Installed to $TARGET"
echo ""

echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Launch Ghostty from Applications"
echo "  2. Add statusline to ~/.claude/settings.json:"
echo ""
echo '     "statusLine": {'
echo '       "type": "command",'
echo '       "command": "~/.claude/statusline-worktree.js"'
echo '     }'
echo ""
echo "  3. Try 'yazi' to browse files with inline previews"
echo "  4. Reload config anytime with Cmd+Shift+,"
echo ""
echo "Requirements for statusline: bun, gh (GitHub CLI)"
