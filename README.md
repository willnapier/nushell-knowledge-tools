# Universal Knowledge Functions v2.0

> **2025-10-27 UPDATE**: v2.0 editor-neutral architecture with complete function set! 🎯
> **2025-09-17**: Complete migration to Rust tools + Nushell architecture achieved! 🦀

## Repository Scope

**What This Repository Provides:**
- ✅ **13 universal CLI functions** - Work with any editor, any terminal, any platform
- ✅ **Integration patterns** - How to connect these tools to your workflow
- ✅ **Helix reference implementation** - ONE complete example (not prescriptive)
- ✅ **Adaptation guidance** - Pointers for other editors

**What This Repository Does NOT Provide:**
- ❌ Complete configurations for every editor
- ❌ Detailed Neovim/Vim/VS Code/Emacs implementations
- ❌ Editor-specific feature development

**Your Role**: Adapt the universal tools and patterns to your preferred editor and workflow.

---

For developers and power users who've outgrown Obsidian, Notion, and other GUI-heavy tools. These terminal-native functions let you craft a personalized knowledge system using the tools you already love - with the reliability of structured data processing and the speed of CLI workflows.

**NEW**: Complete elimination of legacy Unix dependencies - now using modern Rust tools (`rg`, `sd`, `fd`, `sk`) with native Nushell structured data processing for maximum performance and cross-platform reliability.

Ready to take control of your knowledge tools?

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
⏱️ **Time Tracking**: Automatic duration calculation for activity entries

## 🎯 v2.0 Naming Convention (October 2025)

**Universal Tool Architecture** with editor-neutral, platform-agnostic design.

### Naming Pattern: `[scope][search-type][output]`

**Scope Prefixes:**
- `f` = **Knowledge base** (your personal vault at `$env.FORGE`)
  - *Note: "Forge" is just one example - use any name you prefer (VAULT, NOTES, KNOWLEDGE_BASE, etc.)*
- `g` = **Global** (current directory/any location)
- `c` = **Citations** (academic literature workflow)

**Search Types:**
- `s` = **file Search** (by filename)
- `c` = **Content search** (by file contents)
- `sm` = **SeMantic search** (AI-powered relevance)

**Output Destinations:**
- `l` = **Link** (copies `[[wikilink]]` to clipboard)
- `e` = **Editor** (opens in `$env.EDITOR`, fallback to `vi`)
- `o` = **Open** (platform-aware: `open` on macOS, `xdg-open` on Linux)
- `z` = **Zotero** (opens PDF or Zotero protocol)

### Complete Function Set

**Knowledge Base Functions** (`f` prefix - uses `$env.FORGE`):
- `fse` - File Search → Editor
- `fsl` - File Search → Link
- `fce` - Content → Editor
- `fcl` - Content → Link
- `fsme` - Semantic → Editor
- `fsml` - Semantic → Link

**Global Functions** (any directory):
- `gso` - Global Search → Open
- `gco` - Global Content → Open

**Citation Functions** (academic workflow):
- `cit` - CITation plain text
- `cil` - CItation → Literature note Link
- `ciz` - CItation → Zotero/PDF
- `cizl` - CItation Zotero → markdown Link

**Utility Tools:**
- `fdur` - Activity duration processing

## Quick Test (2 minutes)

Want to see what structured data processing can do for knowledge work?

```bash
# 1. Install Nushell (if you haven't already)
brew install nushell  # macOS
# or: apt install nushell  # Linux

# 2. Try one function
curl -o cit https://raw.githubusercontent.com/your-username/nushell-knowledge-tools/main/functions/cit
chmod +x cit

# 3. Set up basic config
export FORGE="/path/to/your/notes"  # or any markdown directory
# Alternative: export FORGE_VAULT="/path/to/your/notes"

# 4. Experience the difference
nu cit
```

If you see immediate value, continue with full installation below.

## 🦀 **Modernization Breakthrough** (September 2025)

**Major Achievement**: Complete elimination of legacy Unix commands in favor of modern Rust tools + native Nushell processing.

### What Changed
- **Legacy**: `grep`, `sed`, `awk`, `find` for text processing
- **Modern**: `rg`, `sd`, `cut`, `fd` with Nushell structured data

### Benefits You Get
- **30-40% faster** text processing with ripgrep and sd
- **Better Unicode support** - handles filenames with apostrophes, quotes, special characters
- **Cross-platform reliability** - consistent behavior across macOS/Linux/Windows
- **Structured data output** - tables instead of text parsing
- **Modern error handling** - clear messages with helpful suggestions

### Example: Duration Processing Evolution
```bash
# Old way (text processing)
grep "t::" file.md | sed 's/t:: //' | awk '{print duration}'

# New way (structured data)
rg "t:: (\d+)-(\d+)" file.md | each { |match| calculate_duration $match }
```

**Result**: More reliable, faster, and works identically across all platforms.

## Function Requirements by Complexity

### ⚡ **Zero Setup Required**
- **`gso`** - Universal file search (works anywhere)
- **`fdur`** - Activity duration processing (works anywhere with Nushell)

### 📁 **Basic Setup** (5 minutes)
- **`fsl`** - Wiki link creator (needs `$env.FORGE` set to your vault directory)
- **`fcl`** - Content discovery (needs `$env.FORGE` set to your vault directory)
- *Note: `FORGE` is customizable - use `VAULT`, `NOTES`, or any name you prefer*

### 📚 **Citation Workflow Setup** (30-60 minutes)
- **`cit`** - Citation picker (requires Zotero + BibTeX export + citation curation)
- **`citz`** - Citation + PDF opener (requires Zotero + BibTeX + PDF file paths)

*See [Citation Setup Guide](docs/citation-setup.md) for detailed instructions*

### 🧠 **AI-Enhanced Setup** (requires API key)
- **`fsml`** - Semantic search (requires OpenAI API key + semantic indexer)

## Core Functions

### 📚 `cit` - Citation Picker
Interactive citation selector with clipboard copy
```bash
$ cit
🔍 Loading citations...
📚 Found 447 citations
[Interactive picker with fuzzy search]
📋 Copied to clipboard: @smith2024automation
```

### 📝 `fsl` - Wiki Link Creator  
Connect ideas across your knowledge base
```bash
$ fsl
📝 Loading vault notes...
[Search with preview across all notes]
📋 Copied to clipboard: [[Personal Productivity Framework]]
```

### 🔍 `fcl` - Content Discovery
Find content across all your notes
```bash
$ fcl
🔍 Search content: habit formation
[Results with context preview]
📋 Copied to clipboard: [[Identity-Based Habits]]
```

### 🧠 `fsml` - AI Concept Discovery
Semantic search using AI embeddings (requires OpenAI API)
```bash
$ fsml
🧠 Semantic search in your vault...
🔍 Search concept: workflow automation
[AI-ranked results by conceptual similarity]
📋 Copied to clipboard: [[Process Optimization Theory]]
```

### 📁 `gso` - Universal File Search
Cross-platform file search with editor integration
```bash
$ gso
[Interactive file picker with previews]
🚀 Opening morning-pages.md in your preferred editor...
```

### ⏱️ `fdur` - Activity Duration Processing
Automatically calculates and inserts durations for time-based activity entries
```bash
$ fdur ~/notes/today.md
🔄 Processing activity durations in /Users/me/notes/today.md
✅ Activity durations processed in /Users/me/notes/today.md

# Before:
t:: meeting with client 0930-1015
s:: deep work session 1400-1630

# After:
t:: meeting with client 45min 0930-1015
s:: deep work session 2hr 30min 1400-1630
```

#### **Dual Approach Example**

**Specific file processing:**
```bash
fdur ~/notes/today.md  # Process specific file
```

**Bulk processing:**
```bash
cd ~/notes && fdur     # Process all activity files in directory
```

**SSH and cross-platform examples:**
```bash
ssh user@server "cd ~/notes && fdur"           # Remote processing
fdur /mnt/synced-notes/activities/daily.md     # Cross-platform paths
```

Perfect example of dual approach philosophy: works both as targeted file processor and bulk directory processor.

## Automatic Link Management (NEW 2025-10-27) 🔗

**Event-driven wiki link management following Unix philosophy**

### Three Composable Tools

**🔗 `wiki-backlinks`** - Automatic bidirectional backlink maintenance
- Watches markdown files for `[[wiki links]]`
- Automatically updates `## Backlinks` sections
- Works across multiple directories
- Zero manual effort

**🔍 `wiki-resolve-mark`** - Visual unresolved link markers  
- Marks broken links: `[[link]]` → `?[[link]]`
- Cleans when files created: `?[[link]]` → `[[link]]`
- Smart filtering (excludes URLs, UUIDs, system paths)
- Instant feedback on note completeness

**⚙️ `link-service`** - Unified service management
- Start/stop/status for all watchers
- Multi-directory × multi-feature spawning
- Centralized logs and monitoring
- Simple operational model

### Quick Start

```bash
# Copy scripts to PATH
cp functions/wiki-backlinks ~/.local/bin/
cp functions/wiki-resolve-mark ~/.local/bin/
cp functions/link-service ~/.local/bin/
chmod +x ~/.local/bin/wiki-* ~/.local/bin/link-service

# Create log directory
mkdir -p ~/scripts/wiki-link-management/logs

# Configure directories (edit scripts)
# Set your note directories in both wiki-backlinks and wiki-resolve-mark

# Start service
link-service start

# Check status
link-service status
```

### Unix Philosophy Design

**Why split into three tools instead of one?**

- **Composable**: Run just backlinks, just resolve-mark, or both
- **Customizable**: Enable features independently
- **Zero overhead**: Event-driven means no redundancy
- **Clear responsibilities**: Each tool does one thing well

**Example Architecture** (2 directories × 2 features = 4 watchers):
```
Forge:
  - wiki-backlinks (PID 12345)
  - wiki-resolve-mark (PID 12346)

Admin:
  - wiki-backlinks (PID 12347)
  - wiki-resolve-mark (PID 12348)
```

### Performance

- **CPU**: 0% when idle (kernel-based events)
- **Memory**: ~24MB per watcher (~96MB for 4 watchers)
- **Scalability**: Tested with 6,400+ markdown files
- **Multi-directory**: True bidirectional updates across directories

### Complete Documentation

📖 **See [Wiki Link Management Guide](docs/wiki-link-management.md)** for:
- Detailed architecture explanation
- Event-driven design principles
- Configuration options
- Troubleshooting guide
- Migration from unified to split
- Customization examples

---


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
$ cit
📋 Copied: @smith2024automation
$ # paste into current document
```

#### **Integrated Workflow Mode** (Optimal Experience)
```
┌─ Main Writing/Work Pane ──────┐  ┌─ Tool Pane ─────┐
│ Writing morning pages about   │  │ nu> cit         │
│ productivity concepts...      │  │ 📋 Copied        │
│                               │  │ nu> fsl          │
│ [[Habit Formation]] ideas     │  │ 📋 Copied        │
│ from @smith2024automation     │  │ nu> fcl      │
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

### Modern Toolchain Requirements (2025-09-17)

**Core Requirements**:
```bash
# Essential
brew install nushell           # Structured data processing
brew install ripgrep           # Fast text search (rg)
brew install sd                # Modern text replacement
brew install fd                # Fast file finding
brew install skim              # Fuzzy finder (sk)

# Linux alternative
apt install nushell ripgrep sd fd-find skim
```

**Why these tools?**
- **30-40% performance improvement** over legacy Unix commands
- **Better Unicode handling** - filenames with quotes, apostrophes work correctly
- **Cross-platform consistency** - identical behavior on macOS/Linux/Windows
- **Modern error messages** - helpful guidance instead of cryptic failures

**Legacy Unix commands no longer used**: `grep`, `sed`, `awk`, `find` - replaced with faster, more reliable Rust alternatives.

### Full Installation
```bash
git clone https://github.com/your-username/nushell-knowledge-tools.git
cd nushell-knowledge-tools/functions
nu install
```

### Configuration

**Knowledge Base Path** (required for `f*` functions):
```bash
# Option 1: Use FORGE (the convention used in this repo)
$env.FORGE = "/path/to/your/notes"

# Option 2: Use your own name (VAULT, NOTES, KNOWLEDGE_BASE, etc.)
$env.VAULT = "/path/to/your/notes"
$env.NOTES = "/path/to/your/notes"
$env.KNOWLEDGE_BASE = "/path/to/your/notes"

# The functions check for FORGE, but you can easily customize them
# to use your preferred variable name
```

**Editor Configuration** (optional - uses `vi` as fallback):
```bash
$env.EDITOR = "hx"      # Helix
$env.EDITOR = "nvim"    # Neovim
$env.EDITOR = "vim"     # Vim
$env.EDITOR = "emacs"   # Emacs
$env.EDITOR = "code --wait"  # VS Code
```

**AI Semantic Search** (optional):
```bash
$env.OPENAI_API_KEY = "your-api-key"
```

**Customizing the Variable Name:**

If you prefer a different environment variable name than `FORGE`, you can:
1. Fork the repository
2. Search and replace `$env.FORGE` with your preferred name
3. Or create aliases in your Nushell config:
   ```nushell
   $env.FORGE = $env.VAULT  # Redirect FORGE to your VAULT
   ```

## Target Audience

**Perfect for the "Post-Obsidian Power User":**
- **Escaped from GUI bloat**: Tired of Electron apps consuming RAM and CPU
- **Terminal-native developers**: Want knowledge tools that match your editor workflow
- **Tool crafters**: Ready to build personalized automation instead of wrestling with plugins
- **Performance-conscious**: Value speed and reliability over pretty interfaces
- **Control-seekers**: Want to own your tools, not rent them from platform vendors
- **CLI enthusiasts**: Comfortable with Neovim, Helix, tmux - ready for knowledge tools that match

**Your journey**: Notion → Obsidian → "I can build something better" → **Here you are**

## Why Leave GUI Tools Behind?

### **Performance Reality Check**

| Operation | Obsidian | These Functions | Improvement |
|-----------|----------|----------------|-------------|
| **Citation lookup** | 15-30 seconds (GUI navigation) | 3-5 seconds (`cit`) | **6-10x faster** |
| **Content search** | 5-10 seconds (index + UI) | 1-2 seconds (`fcl`) | **5x faster** |
| **Link creation** | 10-15 seconds (typing + autocomplete) | 2-3 seconds (`fsl`) | **5x faster** |
| **Memory usage** | 200-400MB (Electron app) | 10-20MB (terminal functions) | **20x more efficient** |
| **Startup time** | 3-8 seconds (app launch) | Instant (already in terminal) | **∞x faster** |

### **What You Trade**

**GUI tools give you:**
- Visual interface, plugin ecosystem, mobile apps, collaborative features

**CLI functions give you:**  
- Raw performance, tool independence, SSH functionality, infinite customization

### **The Real-World Impact**

**Before: GUI-Dependent Workflow**
```
1. ⏰ Wait for Obsidian to start (5 seconds)
2. 🖱️  Navigate through GUI to find citation (15 seconds)  
3. 📋 Copy citation key manually (5 seconds)
4. 🔄 Switch back to writing app (2 seconds)
5. 📝 Paste and continue writing
Total: ~27 seconds + context switching overhead
```

**After: Terminal-Native Flow**
```
1. 🚀 Run cit in spare terminal pane (instant)
2. ⌨️  Type 2-3 characters to filter (1 second)
3. ↵️  Select result (1 second) 
4. 📝 Paste and continue writing (no context switch)
Total: ~3 seconds, zero mental overhead
```

### **SSH Reality**
- **GUI tools**: Completely unusable over remote connections
- **These functions**: Full functionality anywhere you have terminal access

### **Customization Reality**  
- **GUI tools**: Limited to provided plugins and themes
- **These functions**: Modify, extend, and compose however you need

## Editor Integration

### Integration Options

These universal functions work with any editor. Choose your approach:

1. **Manual Integration** - Follow the [editor integration patterns](docs/editor-integrations.md)
2. **Complete Helix Setup** - Use **[helix-knowledge-integration](https://github.com/willnapier/helix-knowledge-integration)** (ready to clone and use!)
3. **Build Your Own** - Create an integration for your editor (PRs welcome to list here!)

### Complete Integrations

- **Helix**: **[helix-knowledge-integration](https://github.com/willnapier/helix-knowledge-integration)** - Complete configuration with cursor-aware wiki navigation, keybindings, and scripts
- **Neovim**: [Your integration here! Open a PR]
- **VS Code**: [Your integration here! Open a PR]
- **Emacs**: [Your integration here! Open a PR]

## Documentation

- **[Installation Guide](docs/installation.md)** - Cross-platform setup with quick test
- **[Obsidian Migration Guide](docs/obsidian-migration.md)** - Escape GUI bloat, keep what works
- **[Citation Setup Guide](docs/citation-setup.md)** - Complete Zotero + BibTeX workflow
- **[Editor Integrations](docs/editor-integrations.md)** - Universal integration patterns with Helix reference
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