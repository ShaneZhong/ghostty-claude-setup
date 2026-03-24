# Ghostty + Claude Code Setup

A complete terminal setup for Claude Code development: Ghostty terminal, Starship prompt, yazi file manager, and a rich statusline.

Based on [BravoHenry's Ghostty终端配置指南](https://z1han.com) and [Peter Steinberger's AI dev workflow](https://steipete.me/posts/2025/optimal-ai-development-workflow).

## Prerequisites

- macOS
- [Homebrew](https://brew.sh)
- [GitHub CLI](https://cli.github.com/) (`brew install gh`) — for statusline PR features
- [Bun](https://bun.sh) — for the statusline script

## Installation

### 1. Install Ghostty

Download from [ghostty.org](https://ghostty.org) and drag to Applications.

### 2. Install the font

```bash
brew install --cask font-maple-mono-nf-cn
```

**Why Maple Mono NF CN?** One font that handles four things:
- Monospace English (programming essential)
- Chinese glyphs built-in (no fallback font needed)
- Nerd Font icons (terminal icons out of the box)
- Programming ligatures (`!=` → `≠`, `=>` → `⇒`, `->` → `→`)

### 3. Copy the Ghostty config

```bash
mkdir -p ~/.config/ghostty
cp config.ghostty ~/.config/ghostty/config
```

Or run the setup script which also installs the statusline:

```bash
./setup.sh
```

### 4. Install Starship prompt

A fast, minimal prompt that shows git status, language versions, and command duration — with zero Claude Code conflicts (unlike Powerlevel10k).

```bash
brew install starship
```

Copy the config:

```bash
cp starship.toml ~/.config/starship.toml
```

Add to `~/.zshrc` (at the end):

```bash
eval "$(starship init zsh)"
```

**Why Starship over Powerlevel10k?** P10k's instant prompt feature [causes Claude Code timeouts and parsing errors](https://github.com/anthropics/claude-code/issues/5428). Starship has zero known conflicts.

### 5. Install yazi (terminal file manager)

Browse files, preview PDFs, images, videos, and code with syntax highlighting — all inline in Ghostty via the Kitty graphics protocol.

```bash
brew install yazi
```

Usage: run `yazi` in Ghostty, navigate with vim keys (`h/j/k/l`), `Enter` to open, `q` to quit. See [yazi-shortcuts.md](yazi-shortcuts.md) for the full reference.

### 6. Install the Claude Code statusline (optional)

The statusline shows context usage %, model name, session duration, git status, PR links, and CI status in your Claude Code status bar.

```bash
cp statusline-worktree.js ~/.claude/
chmod +x ~/.claude/statusline-worktree.js
```

Add to `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/statusline-worktree.js"
}
```

## What's in the config

### Font
- **Maple Mono NF CN** at size 14 with ligatures enabled
- `font-thicken = true` compensates for macOS thin font rendering
- `adjust-cell-height = 3` / `adjust-cell-width = 1` adds breathing room between characters

### Theme
- **Catppuccin** with auto light/dark switching following macOS system appearance
- Latte (warm white) during the day, Mocha (deep blue-grey) at night

### Window
- **Frosted glass**: 88% opacity with blur 30 — readable in sunlight, beautiful in the dark
- **Padding**: 12px horizontal, 10px vertical, auto-balanced and color-extended
- **Session restore**: `window-save-state = always` — restores all windows, tabs, and splits after restart
- **Working directory inheritance**: new tabs/splits inherit the current directory
- **Display P3 colorspace**: wider color gamut on macOS for accurate Catppuccin colors

### Claude Code Optimization
- **160x50 initial window** — enough vertical space for diffs and code blocks
- **Clickable URLs**: `link-url = true` — Cmd+Click file paths and URLs in Claude's output

### Cursor
- Bar style, no blink, full opacity — visible but not distracting

### Mouse & Clipboard
- **Hide cursor while typing** — reduces visual noise
- **Copy on select** — highlight text to copy, no Cmd+C needed
- **Trim trailing spaces** — clean code pastes
- **Focus follows mouse** — hover over a split to focus it, no clicking

### Quick Terminal
- **Ctrl+\`** from any app — slides down from the top of the screen
- Autohides when you click away
- 120ms animation — feels instant but smooth

### Splits
- Unfocused splits get a dark overlay (`#1e1e2e`) so you always know which split is active

### Shell Integration
- Auto-detects zsh/bash/fish
- `no-cursor` feature: lets Ghostty own the cursor style (prevents shell from overriding it)
- **10M line scrollback** — enough for any build log
- Resize overlay shows dimensions briefly in the bottom-right corner

### Security
- **Paste protection**: confirms before pasting multi-line content (prevents hidden `rm -rf /` attacks)
- **Bracketed paste safe**: prevents escape sequence injection

## Known Issue

`macos-titlebar-style = hidden` breaks `Cmd+T` tab creation (creates new windows instead). This setting is disabled in the config. If you prefer the hidden titlebar aesthetic, you'll need to use splits (`Cmd+D`) instead of tabs.

## Keyboard Shortcuts

### Tabs
| Shortcut | Action |
|----------|--------|
| `Cmd+T` | New tab |
| `Cmd+W` | Close current surface |
| `Cmd+1~9` | Jump to tab N |
| `Cmd+Shift+Left/Right` | Previous/next tab |
| `Cmd+Shift+R` | Rename tab (custom keybind) |

### Splits
| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split right |
| `Cmd+Shift+D` | Split bottom |
| `Cmd+Option+H/J/K/L` | Navigate splits (vim-style) |
| `Cmd+Ctrl+H/J/K/L` | Resize splits (40px steps) |
| `Cmd+Shift+E` | Equalize all splits |
| `Cmd+Shift+F` | Fullscreen/restore current split |

### General
| Shortcut | Action |
|----------|--------|
| `Ctrl+\`` | Quick Terminal (global) |
| `Cmd+Shift+Enter` | Toggle fullscreen |
| `Cmd+Shift+,` | Reload config |
| `Cmd+=/-/0` | Zoom in/out/reset |
| `Cmd+K` | Clear screen |

## Recommended Workflow

| Tab | Purpose |
|-----|---------|
| `Cmd+1` | Claude Code main session |
| `Cmd+2` | Manual terminal (git, tests, builds) |
| `Cmd+3` | Dev server / logs |

**Quick scenarios:**
- Claude output too long? → `Cmd+Shift+F` to fullscreen the split
- Need to verify something while Claude runs? → `Cmd+D` for a side split
- Need a quick command from another app? → `Ctrl+\`` for Quick Terminal
- Restart Ghostty? → `claude --continue` to resume your session

## Files

| File | Description |
|------|-------------|
| `config.ghostty` | Ghostty config (copy to `~/.config/ghostty/config`) |
| `starship.toml` | Starship prompt config (copy to `~/.config/starship.toml`) |
| `statusline-worktree.js` | Claude Code statusline script (Steipete's design) |
| `setup.sh` | Full installer script |
| `shortcuts.md` | Ghostty keyboard shortcuts reference |
| `yazi-shortcuts.md` | Yazi keyboard shortcuts reference |

## Credits

- Config: [BravoHenry / @z1han](https://z1han.com) — Ghostty终端配置指南
- Statusline: [Peter Steinberger / @steipete](https://steipete.me) — Claude Code status bar script
