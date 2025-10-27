# Editor Integration Guide

> **Scope**: This guide covers universal integration patterns with Helix as a reference implementation. Users of other editors should adapt these patterns to their editor's capabilities.

## Philosophy

The nushell-knowledge-tools are **editor-agnostic by design**. All core functionality lives in universal CLI functions that work from any terminal context. Editor integrations are **thin wrappers** that invoke these universal tools.

### What This Repository Provides

✅ **Universal CLI functions** (`fse`, `fsl`, `cit`, etc.) - Works with any editor
✅ **General integration patterns** - How to connect editors to universal functions
✅ **Helix reference implementation** - ONE complete example showing the patterns in practice
✅ **Pointers for other editors** - Guidance on adapting patterns to your editor

### What This Repository Does NOT Provide

❌ Complete implementations for Neovim/Vim/VS Code/Emacs
❌ Detailed editor-specific configuration files
❌ Trying to be "the solution" for every editor

**Your role**: Adapt the patterns to your editor's capabilities and workflow.

---

## Universal Integration Patterns

These patterns work across all editors with appropriate adaptation.

### Pattern 1: Clipboard Bridge

**Concept**: Universal functions copy results to clipboard, editor inserts from clipboard

**How it works**:
1. Run universal function in terminal (e.g., `fsl` - Forge Search → Link)
2. Function copies `[[Wiki Link]]` to clipboard
3. Use editor's paste command to insert

**Applicable to**: All functions ending in `l` (link to clipboard)
- `fsl` - File search → wiki link
- `fcl` - Content search → wiki link
- `fsml` - Semantic search → wiki link
- `cit` - Citation → plain text
- `cil` - Citation → literature note link
- `cizl` - Citation → Zotero markdown link

**Editor requirements**: Ability to paste from system clipboard

### Pattern 2: Editor Bridge

**Concept**: Universal functions open files in `$env.EDITOR`

**How it works**:
1. Set `$env.EDITOR` to your editor command
2. Run universal function (e.g., `fse` - Forge Search → Editor)
3. Function invokes `$env.EDITOR` with selected file path

**Applicable to**: All functions ending in `e` (opens in editor)
- `fse` - File search → open in editor
- `fce` - Content search → open in editor
- `fsme` - Semantic search → open in editor

**Editor requirements**: Command-line invocation support
**Configuration**: `export EDITOR=your_editor` (hx, nvim, vim, emacs, code, etc.)

### Pattern 3: Terminal Integration

**Concept**: Run functions from integrated terminal or terminal multiplexer

**How it works**:
1. Keep terminal pane alongside editor
2. Run functions in terminal when needed
3. Results available via clipboard or opened in editor

**Applicable to**: ALL universal functions

**Editor requirements**: None - editor-independent workflow
**Optimal with**: Terminal multiplexers (Zellij, tmux) or split terminal layouts

### Pattern 4: Keybinding Shortcuts

**Concept**: Bind editor keys to invoke universal functions

**How it works**:
1. Configure editor to run shell command on key press
2. Key press executes universal function
3. Result handled via clipboard/editor bridge

**Editor requirements**: Ability to execute shell commands from keybindings
**Varies by editor**: Configuration syntax differs (TOML, Lua, Vimscript, JSON, Elisp)

---

## Helix Reference Implementation

This is **ONE example** showing how these patterns work in practice. **Adapt to your editor**.

### Why Helix as Reference?

- Modal editing workflow common to Vim family
- Modern configuration (TOML)
- Good command piping capabilities
- Active development community

**This is not prescriptive** - your editor may have better or different approaches.

### Integration Examples

#### Example 1: Clipboard Bridge (Wiki Link Insertion)

**Pattern**: Use `fsl` to search files, paste result in editor

**Helix configuration** (`~/.config/helix/config.toml`):
```toml
[keys.normal.space]
# Paste from clipboard (after running fsl externally)
l = ":insert-output pbpaste"
```

**Workflow**:
1. Run `fsl` in terminal
2. Search and select file (copies `[[Note Name]]` to clipboard)
3. In Helix: `Space+l` to paste

**Adaptation to other editors**:
- **Neovim/Vim**: `nnoremap <leader>l "+p` (paste from system clipboard)
- **VS Code**: `Ctrl+V` (standard paste, or custom keybinding)
- **Emacs**: `C-y` (yank from kill ring with system clipboard integration)

#### Example 2: Editor Bridge (File Search and Open)

**Pattern**: Use `fse` to search and open files in editor

**Terminal usage**:
```bash
# Ensure EDITOR is set
export EDITOR=hx

# Run function - it opens file in Helix
fse
```

**No editor configuration needed** - function handles editor invocation

**Adaptation to other editors**:
```bash
export EDITOR=nvim  # Neovim
export EDITOR=vim   # Vim
export EDITOR="code --wait"  # VS Code
export EDITOR=emacs  # Emacs
```

#### Example 3: Advanced - Cursor-Aware Wiki Navigation

**Pattern**: Context-aware processing using editor state

**Note**: This is an **advanced enhancement** showing what's possible. Most users will use the simpler patterns above.

**Helix implementation** (`~/.config/helix/config.toml`):
```toml
[keys.normal.space]
# Wiki link navigation - Space+w (cursor-aware)
w = [
    "extend_to_line_bounds",
    ":sh echo %{selection.column.0} > /tmp/helix-cursor-col.txt",
    ":pipe-to ~/.local/bin/hx-wiki",
    ":buffer-close /tmp/helix-current-link.md",
    ":open /tmp/helix-current-link.md"
]
```

**Script** (`~/.local/bin/hx-wiki` - bash script, 80+ lines):
- Reads current line from Helix
- Reads cursor position from temp file
- Finds nearest `[[wiki link]]` to cursor
- Creates symlink for Helix to open
- Handles file creation if link target doesn't exist

**Key concepts** (adapt to your editor):
1. **Context passing**: Editor writes cursor position to temp file
2. **Pipe processing**: Editor pipes line content to external script
3. **Result communication**: Script creates symlink at known path
4. **File opening**: Editor opens the symlink path

**Adaptation to other editors**:
- **Neovim**: Lua function with `vim.api.nvim_get_current_line()` and `nvim_win_get_cursor()`
- **Vim**: Vimscript using `getline('.')` and `col('.')`
- **VS Code**: Extension API with `editor.document.lineAt()` and `editor.selection`
- **Emacs**: Elisp with `(thing-at-point 'line)` and `(current-column)`

**Implementation note**: The actual `hx-wiki` script lives in personal dotfiles, not this repository. This is an **example of what's possible**, not a provided solution.

---

## Integration Guidelines by Editor

### Neovim/Vim

**Strengths**: Excellent shell integration, Lua/Vimscript flexibility

**Recommended patterns**:
- Terminal integration (`:terminal` command)
- Keybindings to shell commands (`:!fsl`)
- Lua functions for advanced integration
- System clipboard integration (`"+p`)

**Starting point**:
```lua
-- init.lua
vim.keymap.set('n', '<leader>fs', ':!fsl<CR>')  -- Wiki link search
vim.keymap.set('n', '<leader>fc', ':!fcl<CR>')  -- Content search
vim.env.EDITOR = 'nvim'  -- For *e functions
```

### VS Code

**Strengths**: Integrated terminal, extension ecosystem

**Recommended patterns**:
- Integrated terminal with functions
- Tasks to run functions
- Keybindings to terminal commands

**Starting point**:
```json
// settings.json
{
  "terminal.integrated.env": {
    "EDITOR": "code --wait"
  }
}

// keybindings.json
{
  "key": "ctrl+alt+f",
  "command": "workbench.action.terminal.sendSequence",
  "args": { "text": "fsl\n" }
}
```

### Emacs

**Strengths**: Elisp programmability, shell-command integration

**Recommended patterns**:
- Shell commands in buffers
- Elisp wrappers around functions
- Org-mode integration

**Starting point**:
```elisp
;; init.el
(setenv "EDITOR" "emacs")
(global-set-key (kbd "C-c f s") (lambda () (interactive) (shell-command "fsl")))
(global-set-key (kbd "C-c f c") (lambda () (interactive) (shell-command "fcl")))
```

### Other Editors

**General approach**:
1. Check if editor can execute shell commands
2. Check if editor can paste from system clipboard
3. Check if editor can be invoked from command line
4. Use Pattern 1 (Clipboard) as minimum viable integration
5. Use Pattern 2 (Editor Bridge) if CLI invocation works
6. Use Pattern 3 (Terminal) for maximum flexibility

---

## Requirements

All integrations require:

### Core Tools
- **Nushell** - Shell environment for functions
- **Modern Rust tools** - `rg`, `sd`, `fd`, `sk` for performance

Installation:
```bash
# macOS
brew install nushell ripgrep sd fd skim

# Linux (Ubuntu/Debian)
apt install nushell ripgrep fd-find skim
cargo install sd

# Arch Linux
pacman -S nushell ripgrep sd fd skim
```

### Environment Configuration
```bash
# Required for knowledge base functions (f* prefix)
export FORGE="/path/to/your/vault"

# Required for editor bridge functions (*e suffix)
export EDITOR="your_editor_command"

# Optional for semantic search
export OPENAI_API_KEY="your-key"
```

---

## Design Principles

### 1. Universal Tools First
Logic lives in CLI functions, not editor-specific code. This ensures:
- **Portability**: Same tools work everywhere
- **Maintainability**: Single source of truth
- **Testability**: Functions tested independently
- **SSH compatibility**: Works on remote machines

### 2. Thin Editor Layer
Editor integrations should be minimal wrappers:
- **Keybindings**: Map keys to function calls
- **Clipboard integration**: Insert function results
- **Editor invocation**: Configure `$env.EDITOR`

### 3. Adaptation Over Prescription
Every editor has unique strengths. Don't force one pattern:
- **Use editor's native capabilities**
- **Respect editor's idioms**
- **Optimize for editor's workflow**

### 4. Community Contribution
If you create an integration for your editor:
1. Document the pattern clearly
2. Show configuration examples
3. Explain editor-specific considerations
4. Share with the community (PR or discussion)

**Remember**: The goal is showing *how* to integrate, not providing complete implementations for every editor.

---

## Troubleshooting

### "Command not found" errors
- Ensure Nushell and Rust tools are installed
- Check functions are in PATH (`~/.local/bin` or equivalent)
- Verify functions are executable (`chmod +x`)

### Clipboard not working
- macOS: Uses `pbcopy` (built-in)
- Linux: Needs `wl-copy` (Wayland) or `xclip` (X11)
- Check clipboard tools are installed

### Editor bridge not working
- Verify `$env.EDITOR` is set correctly
- Test editor can be invoked from command line
- Ensure editor command waits for file close if needed (e.g., `code --wait`)

### Functions use wrong vault
- Check `$env.FORGE` points to correct directory
- Verify environment variable is exported in shell
- Reload shell configuration after changes

---

## Contributing

Contributions welcome for:
- New integration patterns
- Editor-specific examples (beyond Helix)
- Improved workflows
- Bug fixes in patterns

**Not needed**:
- Complete editor configurations
- Editor-specific feature implementations
- Detailed editor tutorials

**Focus**: Show the pattern, let users adapt to their needs.

---

**Last Updated**: October 2025 (v2.0 universal tool architecture)
**Scope**: Universal patterns + Helix reference implementation
**Philosophy**: Tool-agnostic design with editor-specific adaptation guidance
