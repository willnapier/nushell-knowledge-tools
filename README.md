# Nushell Knowledge Tools

> Cross-platform CLI functions for personal knowledge development using Nushell's structured data processing

Transform your knowledge workflow with Nushell-powered functions that work consistently across terminals, SSH sessions, and platforms. Built for writers, thinkers, and knowledge workers who value reliable data processing and universal accessibility.

## Features

🐚 **Nushell-Powered**: Leverages structured data processing for reliable knowledge operations  
🌍 **Cross-Platform**: Works in any terminal where Nushell runs - local, SSH, containers  
📝 **Knowledge-Focused**: Citation management, note linking, idea development, content discovery  
🔍 **AI-Enhanced**: Optional semantic search using OpenAI embeddings  
⚡ **Zero Setup**: Functions work immediately without configuration  
🔄 **Personal to Public**: Supports journey from private journaling to public sharing  

## Quick Start

### Prerequisites

**Required:**
- [Nushell](https://www.nushell.sh/) shell (the foundation for structured data processing)

**Recommended:**
- [fd](https://github.com/sharkdp/fd) and [sk](https://github.com/lotabout/skim) for file operations
- [ripgrep](https://github.com/BurntSushi/ripgrep) for text search
- [bat](https://github.com/sharkdp/bat) for file previews

### Installation

```bash
git clone https://github.com/your-username/nushell-knowledge-tools.git
cd nushell-knowledge-tools/functions
nu install.nu
```

### Configuration

```bash
# Set your knowledge vault path (Obsidian, Foam, or plain markdown)
$env.OBSIDIAN_VAULT = "/path/to/your/notes"

# Optional: For AI semantic search
$env.OPENAI_API_KEY = "your-api-key"
```

## Core Functions

### 📚 Reference Management

- **`fcit`** - Interactive citation picker with clipboard copy
- **`fcitz`** - Citation picker + PDF opener (integrates with Zotero)

### 📝 Knowledge Navigation

- **`fwl`** - Wiki link picker for knowledge graph navigation
- **`fsearch`** - Content search across your knowledge base

### 🧠 AI-Enhanced Discovery

- **`fsem`** - Semantic search using AI embeddings (requires OpenAI API)

### 📁 File Operations

- **`fsh`** - Cross-platform file search and editor opening

## The Nushell Advantage

Traditional knowledge tools are context-dependent:
- GUI applications that break in SSH sessions
- Bash scripts with fragile text parsing
- Platform-specific shortcuts and integrations

**Nushell Knowledge Tools** provide:
- **Structured data processing**: No more regex parsing - reliable data handling
- **Cross-platform by design**: Automatic OS detection and adaptation
- **SSH-friendly**: Full functionality over remote connections
- **Type safety**: Catch errors before they break your workflow

## Usage Examples

### Daily Journaling to Research Pipeline
```bash
# Start with personal note-taking
fsh                    # Find and open today's journal

# Develop ideas with linking
fwl                    # Create connections between concepts

# Research supporting materials  
fcit                   # Find relevant citations
fcitz                  # Open supporting PDFs

# Discover related thoughts
fsem                   # AI-powered concept discovery
```

### Knowledge Development Workflow
```bash
# Content discovery
fsearch "productivity" # Find all mentions across notes

# Idea development  
fwl                    # Link related concepts

# Research integration
fcit                   # Add supporting citations
```

## Architecture: Why Nushell?

Built on **Nushell's structured data philosophy**:

```nushell
# Traditional bash approach (fragile):
selected=$(cat citations.md | grep -v "^#" | fzf)

# Nushell approach (reliable):
let selected = (open citations.md | lines | where ($it | str starts-with "#") == false | sk)
```

**Benefits:**
- **Type safety**: Structured data prevents parsing errors
- **Cross-platform**: Built-in OS detection and file handling
- **Composability**: Functions work together seamlessly
- **Error handling**: Graceful degradation when tools missing

## Target Audience

Perfect for:
- **Knowledge workers** exploring modern tooling
- **Writers and researchers** who value reliable automation
- **Nushell enthusiasts** wanting practical applications
- **Zettelkasten practitioners** seeking cross-platform tools
- **Digital minimalists** preferring CLI over GUI applications

## Documentation

- [Installation Guide](docs/installation.md) - Cross-platform setup
- [Configuration Reference](docs/configuration.md) - Environment setup
- [Workflow Examples](examples/) - Real-world usage patterns
- [Re-nu Methodology](methodology/re-nu-revolution.md) - Design philosophy

## Contributing

This project demonstrates Nushell's potential for knowledge work automation. Contributions welcome for:

- Additional knowledge workflow functions
- Integration with other note-taking systems
- Cross-platform compatibility improvements
- Documentation and usage examples

## Honest Limitations

- **Requires Nushell**: Not for users wanting bash/zsh compatibility
- **Modern tooling**: Assumes comfort with CLI environments
- **Niche audience**: For those who appreciate structured data benefits
- **Learning curve**: New users need to learn Nushell basics

## License

MIT License - See [LICENSE](LICENSE) for details

---

*Harness Nushell's structured data power for knowledge work. Works everywhere Nushell runs.*