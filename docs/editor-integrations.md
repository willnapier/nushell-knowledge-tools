# Editor Integration Patterns

> How to enhance your favorite editor with universal knowledge functions

## Helix Editor

### Wiki Link Navigation Enhancement (2025-09-17)

**Feature**: Cursor-aware wiki link navigation for lines with multiple links

#### The Problem
Standard wiki link navigation in Helix always opens the first link on a line, even when you have multiple links like:
```markdown
See [[Note A]] for context, but [[Note B]] has the details
```

#### The Solution: Cursor-Aware Detection
A smart enhancement that selects the nearest link to your cursor position.

#### Implementation

**1. Enhanced Helix Config** (`~/.config/helix/config.toml`):
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

**2. Cursor-Aware Script** (`~/.local/bin/hx-wiki`):
```bash
#!/bin/bash

# Smart wiki link handler with cursor awareness
line=$(cat)

# Clear any old temp file first
rm -f /tmp/helix-current-link.md
target_file="/tmp/helix-current-link.md"

# Get cursor column if available
cursor_col=0
if [ -f /tmp/helix-cursor-col.txt ]; then
    cursor_col=$(cat /tmp/helix-cursor-col.txt)
    rm -f /tmp/helix-cursor-col.txt
fi

# Extract all wiki links with their positions
links_with_positions=$(echo "$line" | grep -b -o -E '!?\[\[[^]]+\]\]' 2>/dev/null || echo "")

# If no links found, exit
if [ -z "$links_with_positions" ]; then
    exit 0
fi

# Find the link nearest to cursor position
nearest_link=""
min_distance=999999

while IFS=: read -r pos link_text; do
    # Calculate distance from cursor to start of link
    distance=$((cursor_col > pos ? cursor_col - pos : pos - cursor_col))

    if [ $distance -lt $min_distance ]; then
        min_distance=$distance
        nearest_link="$link_text"
    fi
done <<< "$links_with_positions"

# Extract just the link content from [[link]]
link=$(echo "$nearest_link" | sd '!*\[\[(.*)\]\]' '$1')

# ... rest of script handles file finding and opening
```

#### Key Benefits
- **Natural interaction**: Opens the link you're looking at, not just the first one
- **No precise positioning needed**: Works anywhere on the line
- **Backwards compatible**: Falls back to first link if cursor info unavailable
- **Zero config for users**: Just press `Space+w` as usual

#### Usage
1. Run `:config-reload` in Helix (or press `Space+T` if configured)
2. Navigate to any line with multiple wiki links
3. Position cursor near the link you want
4. Press `Space+w` - it opens the nearest link!

### Wiki Link Insertion
Combine with `fwl` universal function for complete wiki workflow:

```toml
[keys.normal.space]
# Insert wiki link from vault - Space+l
l = ":insert-output pbpaste"  # After using fwl to select
```

Workflow:
1. Run `fwl` in terminal to search vault
2. Select note (copies `[[Note Name]]` to clipboard)
3. Return to Helix, press `Space+l` to insert

## Neovim

### Wiki Link Navigation
Similar pattern can be implemented in Neovim using Lua:

```lua
vim.keymap.set('n', '<leader>w', function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]

    -- Find all wiki links in line
    local links = {}
    for match, pos in line:gmatch('(%[%[.-%]%])()') do
        table.insert(links, {text = match, pos = pos})
    end

    -- Find nearest link to cursor
    local nearest = links[1]
    local min_dist = math.abs(col - links[1].pos)

    for _, link in ipairs(links) do
        local dist = math.abs(col - link.pos)
        if dist < min_dist then
            nearest = link
            min_dist = dist
        end
    end

    -- Extract and open the link
    local note_name = nearest.text:match('%[%[(.-)%]%]')
    -- ... handle file opening
end)
```

## VS Code

### Terminal Integration
Use VS Code's integrated terminal with universal functions:

```json
{
  "terminal.integrated.commandsToSkipShell": [
    "workbench.action.terminal.paste"
  ],
  "keybindings": [
    {
      "key": "ctrl+alt+w",
      "command": "workbench.action.terminal.sendSequence",
      "args": { "text": "fwl\n" }
    }
  ]
}
```

## Design Principles

### The Universal Function Philosophy
Instead of building editor-specific plugins, we:
1. **Create universal CLI tools** that work everywhere
2. **Add thin editor integrations** that call these tools
3. **Maintain single source of truth** in the CLI implementation
4. **Enable cross-editor workflows** with consistent behavior

### Benefits of This Approach
- **Portability**: Same tools work in any editor
- **Maintainability**: Logic lives in one place
- **Flexibility**: Easy to extend or modify
- **Learning curve**: Learn once, use everywhere
- **SSH/Remote**: Works over SSH without plugin installation

## Common Patterns

### Clipboard Bridge Pattern
Most editors can insert from clipboard, so:
1. Universal function selects/processes content
2. Copies result to clipboard
3. Editor keybinding inserts clipboard content

### Symlink Bridge Pattern (Helix-specific)
For dynamic file opening in Helix:
1. Script creates/updates symlink at fixed path
2. Helix opens the fixed path
3. Symlink target determines actual file

### Process Communication Pattern
For cursor-aware features:
1. Editor writes context (cursor position) to temp file
2. Script reads context and processes accordingly
3. Result returned through clipboard or file

## Contributing

Have you created an editor integration? Please share:
1. Document the pattern clearly
2. Show configuration examples
3. Explain any editor-specific limitations
4. Submit a PR to add to this guide

Remember: The goal is enhancing editors with universal tools, not replacing them with editor-specific solutions.