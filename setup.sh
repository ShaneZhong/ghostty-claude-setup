#!/bin/bash
# Ghostty + Claude Code full setup script
# Installs: font, Starship prompt, yazi, Ghostty config, Claude Code statusline
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Ghostty + Claude Code Setup ==="
echo ""

# 1. Font
echo "[1/5] Installing Maple Mono NF CN font..."
if brew list --cask font-maple-mono-nf-cn &>/dev/null; then
  echo "  Already installed, skipping."
else
  brew install --cask font-maple-mono-nf-cn
fi
echo ""

# 2. Starship prompt
echo "[2/5] Installing Starship prompt..."
if command -v starship &>/dev/null; then
  echo "  Already installed ($(starship --version 2>/dev/null | head -1))."
else
  brew install starship
fi
mkdir -p ~/.config
cp "$SCRIPT_DIR/starship.toml" ~/.config/starship.toml
echo "  Config installed to ~/.config/starship.toml"
if ! grep -q 'starship init zsh' ~/.zshrc 2>/dev/null; then
  echo '' >> ~/.zshrc
  echo '# Starship prompt' >> ~/.zshrc
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
  echo "  Added starship init to ~/.zshrc"
else
  echo "  Already in ~/.zshrc, skipping."
fi
echo ""

# 3. Yazi
echo "[3/5] Installing yazi (terminal file manager)..."
if command -v yazi &>/dev/null; then
  echo "  Already installed."
else
  brew install yazi
fi
echo ""

# 4. Ghostty config
echo "[4/5] Installing Ghostty config..."
mkdir -p ~/.config/ghostty
if [ -f ~/.config/ghostty/config ]; then
  echo "  Existing config found — backing up to ~/.config/ghostty/config.bak"
  cp ~/.config/ghostty/config ~/.config/ghostty/config.bak
fi
cp "$SCRIPT_DIR/config.ghostty" ~/.config/ghostty/config
echo "  Installed to ~/.config/ghostty/config"
echo ""

# 5. Claude Code statusline
echo "[5/5] Installing Claude Code statusline..."
TARGET="$HOME/.claude/statusline-worktree.js"
mkdir -p "$HOME/.claude"
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
echo "  4. Reload Ghostty config anytime with Cmd+Shift+,"
echo "  5. Open a new tab to see the Starship prompt"
echo ""
echo "Requirements for statusline: bun, gh (GitHub CLI)"
