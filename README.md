# Universal Knowledge Functions

> Cross-platform CLI functions that work with YOUR choice of terminal, editor, and multiplexer

Transform your knowledge workflow with reliable functions that work consistently everywhere - local terminals, SSH sessions, containers, colleague's machines. Built with Nushell's structured data processing for bulletproof reliability.

## Universal Compatibility

🖥️  **Any Terminal**: WezTerm, iTerm, Alacritty, GNOME Terminal, Windows Terminal  
✏️  **Any Editor**: Helix, Neovim, Vim, VS Code, Emacs  
🔀 **Any Multiplexer**: Zellij, tmux, screen, or none at all  
🌍 **Any Platform**: macOS, Linux, Windows (WSL)  
🔐 **Any Environment**: Local machine, SSH server, Docker container  

## What You Get

📚 **Citation Management**: Interactive picker with clipboard integration  
📝 **Note Linking**: Wiki-style connections between ideas  
🔍 **Content Discovery**: Fast search across your knowledge base  
🧠 **AI Discovery**: Semantic search using OpenAI embeddings (optional)  
📁 **File Operations**: Universal file search with editor integration  

## Quick Test (2 minutes)

Want to see what structured data processing can do for knowledge work?

```bash
# 1. Install Nushell (if you haven't already)
brew install nushell  # macOS
# or: apt install nushell  # Linux

# 2. Try one function
curl -o fcit https://raw.githubusercontent.com/your-username/nushell-knowledge-tools/main/functions/fcit.nu
chmod +x fcit

# 3. Set up basic config
export OBSIDIAN_VAULT="/path/to/your/notes"  # or any markdown directory

# 4. Experience the difference
nu fcit
```

If you see immediate value, continue with full installation below.

## Core Functions

### 📚 `fcit` - Citation Picker
Interactive citation selector with clipboard copy
```bash
$ fcit
🔍 Loading citations...
📚 Found 447 citations
[Interactive picker with fuzzy search]
📋 Copied to clipboard: @smith2024automation
```

### 📝 `fwl` - Wiki Link Creator  
Connect ideas across your knowledge base
```bash
$ fwl
📝 Loading vault notes...
[Search with preview across all notes]
📋 Copied to clipboard: [[Personal Productivity Framework]]
```

### 🔍 `fsearch` - Content Discovery
Find content across all your notes
```bash
$ fsearch
🔍 Search content: habit formation
[Results with context preview]
📋 Copied to clipboard: [[Identity-Based Habits]]
```

### 🧠 `fsem` - AI Concept Discovery
Semantic search using AI embeddings (requires OpenAI API)
```bash
$ fsem
🧠 Semantic search in your vault...
🔍 Search concept: workflow automation
[AI-ranked results by conceptual similarity]
📋 Copied to clipboard: [[Process Optimization Theory]]
```

### 📁 `fsh` - Universal File Search
Cross-platform file search with editor integration
```bash
$ fsh
[Interactive file picker with previews]
🚀 Opening morning-pages.md in your preferred editor...
```

## Why This Approach Works

### Traditional Knowledge Tools Problems:
- **Context-dependent**: Only work in specific applications
- **Platform-specific**: Different tools for Mac/Linux/Windows  
- **Fragile parsing**: Break on special characters or formats
- **GUI-bound**: Useless over SSH or in containers

### Universal Functions Solution:
- **Tool-agnostic**: Work with any terminal/editor combination
- **Structured data**: Reliable parsing using Nushell's type system
- **Cross-platform**: Automatic OS detection and adaptation
- **SSH-friendly**: Full functionality over remote connections

## Optimal Workflow Integration

### **Two Ways to Use These Functions**

#### **Standalone Mode** (Works Anywhere)
```bash
# Stop current work → run function → return to work
$ fcit
📋 Copied: @smith2024automation
$ # paste into current document
```

#### **Integrated Workflow Mode** (Optimal Experience)
```
┌─ Main Writing/Work Pane ──────┐  ┌─ Tool Pane ─────┐
│ Writing morning pages about   │  │ nu> fcit         │
│ productivity concepts...      │  │ 📋 Copied        │
│                               │  │ nu> fwl          │
│ [[Habit Formation]] ideas     │  │ 📋 Copied        │
│ from @smith2024automation     │  │ nu> fsearch      │
│                               │  │ 📋 Copied        │
└───────────────────────────────┘  └──────────────────┘
```

### **Why Integrated Mode Flows Better**

**The workflow "flow" comes from:**
- **Parallel processing**: Functions run alongside main work, not interrupting it
- **Context preservation**: Stay in your document while tools operate
- **Instant availability**: Spare Nushell prompt ready when inspiration strikes
- **Seamless integration**: Paste results without losing focus or mental state

### **Recommended Stack for Optimal Experience**

**For the best integrated workflow:**
- **Terminal**: [WezTerm](https://wezfurlong.org/wezterm/) (GPU-accelerated, reliable rendering)
- **Multiplexer**: [Zellij](https://zellij.dev) (floating panes, easy workspace management)
- **Shell**: [Nushell](https://nushell.sh) (obviously required)
- **Editor**: Your choice - [Helix](https://helix-editor.com), Neovim, VS Code, etc.

**Minimum requirements:**
- **Shell**: Nushell (required for functions)
- **Context**: Any terminal/multiplexer combination (functions still work)

**The difference**: Standalone mode provides the functionality. Integrated mode provides the *workflow*.

## The Nushell Advantage

These functions demonstrate why structured data matters:

```bash
# Traditional bash (fragile):
selected=$(cat notes.txt | grep -v "^#" | fzf)

# Nushell approach (reliable):
let selected = (open notes.txt | lines | where ($it | str starts-with "#") == false | sk)
```

**Benefits you get:**
- **Type safety**: Structured data prevents parsing errors
- **Error handling**: Graceful degradation when tools missing  
- **Composability**: Functions work together seamlessly
- **Cross-platform**: Built-in OS detection and file handling

## Installation

### Full Installation
```bash
git clone https://github.com/your-username/nushell-knowledge-tools.git
cd nushell-knowledge-tools/functions
nu install.nu
```

### Configuration
```bash
# Required: Set your knowledge vault path
$env.OBSIDIAN_VAULT = "/path/to/your/notes"  # Obsidian, Foam, or any markdown directory

# Optional: For AI semantic search
$env.OPENAI_API_KEY = "your-api-key"
```

## Target Audience

Perfect for:
- **Knowledge workers** who want reliable automation
- **Writers and researchers** frustrated with fragmented tools
- **Terminal enthusiasts** interested in modern tooling
- **Remote workers** needing SSH-friendly workflows
- **Cross-platform users** wanting consistent experiences
- **Nushell curious** people wanting practical applications

## Real-World Impact

### Before: Context-Dependent Chaos
- Different tools on different machines
- GUI applications that break over SSH
- Fragile bash scripts with regex parsing
- Platform-specific shortcuts and integrations

### After: Universal Reliability
- Same commands work everywhere
- Full functionality over SSH
- Structured data prevents parsing errors  
- Consistent experience across all environments

## Documentation

- **[Installation Guide](docs/installation.md)** - Cross-platform setup with quick test
- **[Configuration Reference](docs/configuration.md)** - Environment setup options
- **[Workflow Examples](examples/)** - Real-world usage patterns
- **[Rust Ecosystem Guide](docs/rust-ecosystem.md)** - Why modern terminal tools matter
- **[Nushell Benefits](docs/nushell-benefits.md)** - Structured data advantages explained

## Honest Trade-offs

### What You Get:
- ✅ **Reliable data processing** (no more regex parsing failures)
- ✅ **Cross-platform consistency** (same experience everywhere)
- ✅ **Modern tooling benefits** (better error handling, type safety)
- ✅ **SSH-friendly workflows** (full functionality over remote connections)

### What You Give Up:
- ❌ **Shell familiarity** (requires learning basic Nushell syntax)
- ❌ **Immediate availability** (Nushell not installed by default)
- ❌ **Bash ecosystem** (can't directly use bash-specific tools)

### Is It Worth It?
If you value **reliable automation over familiar tooling**, absolutely. These functions demonstrate what's possible when you choose tools designed for structured data processing.

## Contributing

Contributions welcome for:
- **Additional knowledge workflow functions**
- **Integration with other note-taking systems**  
- **Cross-platform compatibility improvements**
- **Documentation and usage examples**

## License

MIT License - See [LICENSE](LICENSE) for details

---

*Experience reliable knowledge automation. Works everywhere Nushell runs.*