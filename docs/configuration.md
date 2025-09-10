# Configuration Reference

## Environment Variables

### Core Configuration

#### OBSIDIAN_VAULT (Required)
Path to your Obsidian vault directory.

```nushell
$env.OBSIDIAN_VAULT = "/Users/username/Documents/MyVault"
```

**Used by**: `fcit`, `fcitz`, `fwl`, `fsearch`

#### EDITOR (Recommended)
Your preferred text editor for file operations.

```nushell
$env.EDITOR = "hx"  # Helix
$env.EDITOR = "nvim"  # Neovim
$env.EDITOR = "vim"  # Vim
$env.EDITOR = "code"  # VS Code
```

**Used by**: `fsh`
**Default behavior**: Auto-detects available editors (hx → nvim → vim → code)

### AI/Semantic Search

#### OPENAI_API_KEY (Optional)
OpenAI API key for semantic search functionality.

```nushell
$env.OPENAI_API_KEY = "sk-..."
```

**Used by**: `fsem`
**Cost**: Approximately $0.002 per search query

## File Structure Requirements

### Obsidian Vault Structure

```
your-vault/
├── ZET/
│   ├── citations.md      # Citation database
│   └── library.bib       # BibTeX library (for fcitz)
└── ...
```

#### citations.md Format
Plain text file with one citation per line:
```
@author2023key
@smith2024study  
@johnson2022analysis
```

#### library.bib Format
Standard BibTeX format:
```bibtex
@article{author2023key,
    title={Article Title},
    author={Author Name},
    year={2023},
    file={/path/to/pdf/file.pdf}
}
```

## Platform-Specific Configuration

### macOS
Default configuration works out of the box.

**Clipboard**: Uses `pbcopy`/`pbpaste`
**File opening**: Uses `open`
**Package manager**: Homebrew recommended

### Linux
Additional clipboard tool may be needed.

**Clipboard**: Auto-detects `xclip` or `wl-clipboard`
```bash
# X11
apt install xclip

# Wayland
apt install wl-clipboard
```

**File opening**: Uses `xdg-open`

### Windows (WSL)
Works in Windows Subsystem for Linux.

**Clipboard**: May require additional setup
**File opening**: Uses `start`

## Advanced Configuration

### Custom Search Directories

For non-standard vault layouts, you can override default paths:

```nushell
# Custom citation file location
$env.CITATION_FILE = "/path/to/custom/citations.txt"

# Custom BibTeX library location  
$env.BIBTEX_FILE = "/path/to/custom/library.bib"
```

### Performance Tuning

#### File Search Optimization
```nushell
# Exclude large directories from search
alias fsh = fd . --type f --exclude node_modules --exclude .git --exclude target
```

#### Preview Configuration
```nushell
# Custom bat theme for previews
$env.BAT_THEME = "Solarized (dark)"
```

### Integration with Other Tools

#### Zotero Integration
For `fcitz` PDF opening:
1. Ensure Zotero is installed
2. Library.bib should include `file` fields with correct paths
3. Zotero should be running for URL scheme support

#### Semantic Search Setup
Requires separate semantic-indexer setup:
```bash
# Install semantic search tools (separate project)
pip install semantic-indexer
semantic-indexer --setup
```

## Configuration Files

### Nushell Environment (~/.config/nushell/env.nu)
```nushell
# Academic workflow tools configuration
$env.OBSIDIAN_VAULT = "/Users/username/Obsidian/Research"
$env.EDITOR = "hx"
$env.OPENAI_API_KEY = "sk-..."

# PATH configuration
$env.PATH = ($env.PATH | append $"($env.HOME)/.local/bin")
```

### Shell Integration
If using these tools from other shells:

#### Bash (~/.bashrc)
```bash
export OBSIDIAN_VAULT="/Users/username/Obsidian/Research"
export EDITOR="hx"
export OPENAI_API_KEY="sk-..."
```

#### Zsh (~/.zshrc)
```zsh
export OBSIDIAN_VAULT="/Users/username/Obsidian/Research"
export EDITOR="hx"
export OPENAI_API_KEY="sk-..."
```

## Validation

### Test Configuration
```bash
# Test environment variables
echo $env.OBSIDIAN_VAULT
echo $env.EDITOR
echo $env.OPENAI_API_KEY

# Test file access
ls $"($env.OBSIDIAN_VAULT)/ZET/citations.md"
```

### Debug Mode
Most functions will show helpful error messages:
```bash
fcit  # Will show specific error if citations.md not found
fwl   # Will show error if OBSIDIAN_VAULT not set
```

## Security Considerations

### API Keys
- Store API keys in environment variables, not in scripts
- Consider using a secrets manager for production environments
- Rotate API keys periodically

### File Permissions
- Ensure citation files are readable by your user
- PDF files should have appropriate access permissions
- Vault directories should not be world-readable if they contain sensitive research

## Troubleshooting

### Common Issues

**"OBSIDIAN_VAULT not set"**
```nushell
$env.OBSIDIAN_VAULT = "/path/to/vault"
```

**"Citations file not found"**
- Check vault path is correct
- Ensure `ZET/citations.md` exists
- Verify file is readable

**"No editor found"**
```nushell
$env.EDITOR = "nvim"  # or your preferred editor
```

**"Semantic search failed"**
- Verify OPENAI_API_KEY is set
- Check semantic-indexer is installed
- Ensure internet connectivity for API calls

### Logging
For debugging, enable verbose output:
```bash
# Run with debug output
nu --log-level debug fcit
```