# GitHub Nushell-Tools Repository Documentation Update

## Cross-Platform Academic Workflow Integration

### Summary for README.md

Add this section to your nushell-tools repository README:

---

## Cross-Platform Academic Workflow

The universal academic workflow tools demonstrate the power of cross-platform design in Nushell. These functions work identically across macOS, Linux, and Windows, providing seamless research workflows regardless of platform.

### Universal Academic Functions

All functions automatically detect the platform and use appropriate tools:

```nushell
# Universal citation browser
def fcitz [] {
    # Browse Zotero library → markdown links with automated PDF opening
    # Platform detection built-in for clipboard and URL handling
}

# Universal wiki link picker
def fwl [] {
    # Search vault files → copy wiki links to clipboard
    # Cross-platform clipboard operations
}

# Universal semantic search
def fsem [] {
    # AI-powered semantic search → relevance-ranked results
    # Universal clipboard integration
}
```

### Cross-Platform Implementation

#### Clipboard Operations
```nushell
# Automatic platform detection
if $nu.os-info.name == "macos" {
    $text | ^pbcopy
} else if $nu.os-info.name == "linux" {
    if (which wl-copy | is-not-empty) {
        $text | ^wl-copy  # Wayland
    } else {
        $text | ^xclip -selection clipboard  # X11
    }
}
```

#### File/URL Opening
```nushell
# Universal opener
def cross-platform-open [target: string] {
    if $nu.os-info.name == "macos" {
        ^open $target
    } else if $nu.os-info.name == "linux" {
        ^xdg-open $target
    } else if $nu.os-info.name == "windows" {
        ^start $target
    }
}
```

### Complete Academic Workflow

```bash
# 1. Find and reference papers
fcitz
# → Interactive Zotero browser
# → Select paper → [Paper Title](zotero://select/items/@key) in clipboard

# 2. Insert into notes
# Paste → Clean markdown link in your writing

# 3. Open for reading (in editor with Space+o keybinding)
# → Opens Zotero, selects paper, automatically opens PDF
```

### Platform Requirements

#### Linux Setup
```bash
# Clipboard support
sudo apt install wl-clipboard  # Wayland
sudo apt install xclip         # X11

# Key automation (for Zotero integration)
sudo apt install xdotool

# Zotero (if not installed)
wget -qO- https://github.com/retorquere/zotero-deb/releases/latest/download/install.sh | sudo bash
```

#### Windows Setup
```powershell
# Windows Terminal recommended
# Zotero desktop app
# Functions automatically use Windows clipboard and file associations
```

### Design Philosophy

This implementation demonstrates **Universal Tool Architecture**:

- **Single interface** across all platforms
- **Automatic platform detection** with graceful degradation
- **Tool availability checking** with helpful error messages
- **Modular design** for easy platform additions

The academic workflow exemplifies how Nushell's cross-platform capabilities enable truly universal tools that adapt to users rather than requiring users to adapt to platform limitations.

---

## New Repository Files to Add

### 1. `examples/academic-workflow.nu`

```nushell
# Cross-Platform Academic Workflow Examples
# Demonstrates universal tool architecture in Nushell

# Universal clipboard function
def clipboard-copy [] {
    let input = $in
    if $nu.os-info.name == "macos" {
        $input | ^pbcopy
    } else if $nu.os-info.name == "linux" {
        if (which wl-copy | is-not-empty) {
            $input | ^wl-copy
        } else if (which xclip | is-not-empty) {
            $input | ^xclip -selection clipboard
        } else {
            print "❌ Install clipboard tool: sudo apt install wl-clipboard xclip"
        }
    } else if $nu.os-info.name == "windows" {
        $input | ^clip
    }
}

# Universal file opener
def open-file [file: string] {
    if $nu.os-info.name == "macos" {
        ^open $file
    } else if $nu.os-info.name == "linux" {
        ^xdg-open $file
    } else if $nu.os-info.name == "windows" {
        ^start $file
    }
}

# Academic citation browser (simplified example)
def citation-picker [] {
    # Read citations from BibTeX file
    let citations = (
        open ~/library.bib
        | lines
        | where ($it | str contains "@")
        | parse --regex '@\w+\{([^,]+),'
        | get capture0
    )

    # Interactive selection with fuzzy finder
    let selected = (
        $citations
        | str join "\n"
        | ^sk --prompt "📚 Citation: "
    )

    # Create markdown link and copy to clipboard
    let link = $"[[($selected)]]"
    $link | clipboard-copy
    print $"✅ Copied: ($link)"
}

# Example usage:
# citation-picker
# → Select citation → [[key]] copied to clipboard
```

### 2. `docs/cross-platform-patterns.md`

```markdown
# Cross-Platform Patterns in Nushell

## Platform Detection

```nushell
# Basic platform detection
if $nu.os-info.name == "macos" {
    # macOS-specific code
} else if $nu.os-info.name == "linux" {
    # Linux-specific code
} else if $nu.os-info.name == "windows" {
    # Windows-specific code
}
```

## Tool Availability Checking

```nushell
# Check if external tool exists
if (which tool-name | is-not-empty) {
    ^tool-name $args
} else {
    print "❌ Install tool-name: package-manager install tool-name"
}
```

## Graceful Degradation

```nushell
# Try multiple tools in order of preference
def cross-platform-clipboard-copy [] {
    let input = $in
    if $nu.os-info.name == "linux" {
        if (which wl-copy | is-not-empty) {
            $input | ^wl-copy
        } else if (which xclip | is-not-empty) {
            $input | ^xclip -selection clipboard
        } else if (which xsel | is-not-empty) {
            $input | ^xsel --clipboard --input
        } else {
            print "❌ No clipboard tool found"
            print "Install: sudo apt install wl-clipboard xclip"
        }
    }
}
```
```

### 3. Update to `README.md`

Add a new section titled "Cross-Platform Design" that highlights:

1. **Universal Tool Philosophy** - Tools that work everywhere users have terminals
2. **Academic Workflow Case Study** - Complete research workflow example
3. **Platform Detection Patterns** - Reusable cross-platform techniques
4. **Community Contributions** - How others can add platform-specific implementations

---

## Repository Structure Suggestion

```
nushell-tools/
├── README.md (updated with cross-platform section)
├── examples/
│   ├── academic-workflow.nu (new)
│   └── cross-platform-utilities.nu (new)
├── docs/
│   ├── cross-platform-patterns.md (new)
│   └── academic-workflow-guide.md (new)
└── scripts/
    ├── clipboard-utils.nu (new)
    └── file-operations.nu (new)
```

This documentation demonstrates how Nushell enables truly universal tools through structured cross-platform design, using the academic workflow as a comprehensive real-world example.