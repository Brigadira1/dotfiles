# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using lazy.nvim for plugin management. The config is organized under the `brigadira` namespace.

## Architecture

```
init.lua                          # Entry point - loads core and lazy
lua/brigadira/
├── core/
│   ├── init.lua                  # Loads options and keymaps
│   ├── options.lua               # Vim options (tabs, search, clipboard, etc.)
│   └── keymaps.lua               # Global keymaps and leader key (Space)
├── lazy.lua                      # lazy.nvim bootstrap and plugin imports
└── plugins/                      # Each file returns a lazy.nvim plugin spec
    ├── init.lua                  # Plugins without configuration
    ├── lsp/
    │   ├── lspconfig.lua         # LSP servers and keymaps
    │   └── mason.lua             # LSP/tool auto-installation
    ├── formatting.lua            # conform.nvim - format on save
    ├── linting.lua               # nvim-lint configuration
    └── [plugin].lua              # One file per plugin
```

## Key Configuration Details

**Leader key:** Space

**Plugin loading:** lazy.nvim imports from `brigadira.plugins` and `brigadira.plugins.lsp`

**LSP servers:** pyright, ruff, html, emmet_ls, ts_ls, lua_ls (auto-installed via Mason)

**Formatters:**
- Python: ruff (format on save)
- Lua: stylua
- Web (CSS/HTML/JSON/YAML/Markdown): prettier

**Linting:** ruff for Python (auto-runs on save and insert leave)

**Python workflow:**
- Uses `uv run -m` for running Python modules (`<leader>ri`)
- Pyright for type checking with Ruff handling linting/formatting
- Ruff hover is disabled to prefer Pyright's hover

**File management:** yazi.nvim (`<leader>-` to open, `<leader>cw` for cwd)

**Colorscheme:** tokyonight (night style with custom colors)

## Notable Keymaps

| Keymap | Action |
|--------|--------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fs` | Live grep |
| `<leader>-` | Open yazi file manager |
| `<leader>m` | Add file to Harpoon |
| `<leader>hl` | Open Harpoon list |
| `<leader>db` | Toggle breakpoint (DAP) |
| `<leader>dc` | Continue debugging |
| `<leader>fm` | Format file |
| `<leader>l` | Trigger linting |
| `<leader>zf` | Search Obsidian notes |
| `gd` | Go to definition |
| `gR` | Show references |
| `K` | Show hover documentation |

## Debugging

DAP (Debug Adapter Protocol) is configured for Python via debugpy. Full debugging keymaps use `<leader>d` prefix.

## Obsidian Integration

Obsidian.nvim configured with workspace at `~/Obsidian/`, notes go to `0. Inbox` subfolder.

## Adding New Plugins

Create a new file in `lua/brigadira/plugins/` returning a lazy.nvim plugin spec table. It will be auto-loaded.
