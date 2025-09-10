# Universal Academic Workflow Tools

> Cross-platform command-line tools for academic research workflows using structured data processing

Transform your academic workflow with universal CLI functions that work consistently across terminals, SSH sessions, and platforms. Built with Nushell for reliable structured data processing and cross-platform compatibility.

## Features

🌍 **Universal Access**: Works in any terminal - local, SSH, containers, colleague's machine  
📚 **Academic Focused**: Citation management, PDF access, knowledge navigation  
🔍 **AI-Powered**: Semantic search using OpenAI embeddings  
⚡ **Zero Dependencies**: Core functions work without external services  
📊 **Structured Data**: Leverages Nushell's structured data processing  

## Quick Start

### Prerequisites

- [Nushell](https://www.nushell.sh/) shell
- [fd](https://github.com/sharkdp/fd) and [sk](https://github.com/lotabout/skim) for file operations
- [ripgrep](https://github.com/BurntSushi/ripgrep) for text search
- [bat](https://github.com/sharkdp/bat) for file previews

### Installation

```bash
git clone https://github.com/your-username/academic-workflow-tools.git
cd academic-workflow-tools/functions
nu install.nu
```

### Configuration

```bash
# Set your Obsidian vault path
$env.OBSIDIAN_VAULT = "/path/to/your/vault"

# Optional: For AI semantic search
$env.OPENAI_API_KEY = "your-api-key"
```

## Core Functions

### 📚 Citation Management

- **`fcit`** - Interactive citation picker with clipboard copy
- **`fcitz`** - Citation picker + PDF opener (integrates with Zotero)

### 📝 Knowledge Navigation

- **`fwl`** - Wiki link picker for knowledge graph navigation
- **`fsearch`** - Content search across your knowledge base

### 🧠 AI-Powered Discovery

- **`fsem`** - Semantic search using AI embeddings (requires OpenAI API)

### 📁 File Operations

- **`fsh`** - Universal file search and editor opening

## The Universal Tool Philosophy

Traditional academic tools are context-dependent:
- Keyboard shortcuts that only work in specific applications
- GUI-bound workflows that break in SSH sessions
- Platform-specific integrations

These tools follow the **Universal Tool Architecture**:
- **Context-independent**: Work in any terminal environment
- **Platform-agnostic**: macOS, Linux, Windows support built-in
- **SSH-friendly**: Full functionality over remote connections
- **Structured data**: Reliable parsing and processing using Nushell

## Usage Examples

### Citation Workflow
```bash
# Pick and copy citation to clipboard
fcit

# Find and open PDF from citation
fcitz
```

### Knowledge Navigation
```bash
# Pick wiki link to copy
fwl

# Search content across vault
fsearch
```

### AI-Powered Research
```bash
# Find related notes by concept
fsem
```

## Architecture

Built on the **Re-nu Revolution** methodology - systematic migration from context-dependent bash scripts to universal Nushell functions with:

- **Cross-platform detection**: Automatic OS-specific behavior
- **Structured data processing**: Reliable parsing of complex formats
- **Graceful degradation**: Works with or without optional dependencies
- **Universal accessibility**: Same interface across all environments

## Documentation

- [Installation Guide](docs/installation.md)
- [Configuration Reference](docs/configuration.md)  
- [Workflow Examples](examples/)
- [Re-nu Methodology](methodology/re-nu-revolution.md)

## Contributing

This project demonstrates the transformation from personal dotfiles to shareable universal tools. Contributions welcome for:

- Additional academic workflow functions
- Cross-platform compatibility improvements
- Documentation and examples

## License

MIT License - See [LICENSE](LICENSE) for details

---

*Transform your academic workflow from context-dependent to universal. Works everywhere Nushell runs.*