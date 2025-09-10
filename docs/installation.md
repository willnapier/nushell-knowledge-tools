# Installation Guide

## Quick Test (2 Minutes)

Want to see if these functions are worth your time? Here's the fastest way to try them:

### Minimal Setup
```bash
# 1. Install Nushell (if not already installed)
brew install nushell  # macOS
# or: apt install nushell  # Linux

# 2. Download one function to test
curl -o fcit https://raw.githubusercontent.com/your-username/nushell-knowledge-tools/main/functions/fcit.nu
chmod +x fcit

# 3. Set basic config (use any markdown directory)
export OBSIDIAN_VAULT="/path/to/your/notes"

# 4. Test it
nu fcit
```

If you see immediate value, continue with full installation below.

## Full Installation

### Prerequisites

### Required Tools

1. **Nushell** - The foundation for structured data processing in knowledge work
   ```bash
   # macOS
   brew install nushell
   
   # Linux
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   cargo install nu
   
   # Or via package manager
   apt install nushell  # Ubuntu/Debian
   dnf install nushell  # Fedora
   ```

2. **fd** - Fast file finder
   ```bash
   # macOS
   brew install fd
   
   # Linux
   apt install fd-find  # Ubuntu/Debian
   dnf install fd-find  # Fedora
   ```

3. **skim** - Fuzzy finder
   ```bash
   # macOS
   brew install sk
   
   # Linux
   cargo install skim
   ```

4. **ripgrep** - Fast text search
   ```bash
   # macOS
   brew install ripgrep
   
   # Linux
   apt install ripgrep  # Ubuntu/Debian
   dnf install ripgrep  # Fedora
   ```

5. **bat** - Enhanced file viewer (optional, for previews)
   ```bash
   # macOS
   brew install bat
   
   # Linux
   apt install bat  # Ubuntu/Debian
   dnf install bat  # Fedora
   ```

## Installation Methods

### Method 1: Clone and Install

```bash
git clone https://github.com/your-username/nushell-knowledge-tools.git
cd nushell-knowledge-tools/functions
nu install.nu
```

### Method 2: Manual Installation

1. Download individual function files
2. Copy to your `~/.local/bin` directory (or any directory in your PATH)
3. Make them executable:
   ```bash
   chmod +x ~/.local/bin/fcit
   chmod +x ~/.local/bin/fcitz
   chmod +x ~/.local/bin/fwl
   chmod +x ~/.local/bin/fsem
   chmod +x ~/.local/bin/fsh
   chmod +x ~/.local/bin/fsearch
   ```

### Method 3: Direct Download

```bash
# Download specific functions you want
curl -o ~/.local/bin/fcit https://raw.githubusercontent.com/your-username/nushell-knowledge-tools/main/functions/fcit.nu
chmod +x ~/.local/bin/fcit
```

## PATH Configuration

Ensure your installation directory is in your PATH. Add to your shell configuration:

### Nushell (~/.config/nushell/env.nu)
```nushell
$env.PATH = ($env.PATH | append $"($env.HOME)/.local/bin")
```

### Bash/Zsh (~/.bashrc or ~/.zshrc)
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Environment Variables

### Required for Knowledge Functions
```nushell
# Your knowledge vault (Obsidian, Foam, or plain markdown directory)
$env.OBSIDIAN_VAULT = "/path/to/your/notes"
```

### Required for Semantic Search
```nushell
$env.OPENAI_API_KEY = "your-openai-api-key"
```

### Optional Editor Configuration
```nushell
$env.EDITOR = "hx"  # or "nvim", "vim", "code", etc.
```

## Verification

Test the installation with your preferred workflow:

### Test Individual Functions
```bash
# Universal file search (works anywhere)
fsh

# Citation management (requires vault setup)
fcit

# Wiki link creation (requires vault setup)  
fwl

# Content discovery (requires vault setup)
fsearch

# AI semantic search (requires OpenAI API key)
fsem
```

### Test Tool Choice Independence
```bash
# Same functions work with any editor
EDITOR=nvim fsh    # Opens in Neovim
EDITOR=code fsh    # Opens in VS Code  
EDITOR=vim fsh     # Opens in Vim

# Same functions work with any terminal
# - Try in iTerm2, Alacritty, GNOME Terminal
# - Try over SSH connection
# - Try in tmux or Zellij session
```

## Troubleshooting

### "Command not found"
- Verify the installation directory is in your PATH
- Check file permissions (should be executable)
- Restart your shell or run `source ~/.config/nushell/env.nu`

### "No citations found"
- Verify `$env.OBSIDIAN_VAULT` points to correct directory
- Check that `ZET/citations.md` exists in your vault
- Ensure the citations file has the expected format

### "Semantic search failed"
- Verify `$env.OPENAI_API_KEY` is set
- Check that semantic-indexer is installed and configured
- Run `semantic-status` if available

### Preview not working
- Install `bat` for enhanced file previews
- Check that files are readable/exist

## Platform-Specific Notes

### macOS
- Uses `pbcopy`/`pbpaste` for clipboard operations
- Uses `open` for file/URL opening
- Homebrew is the recommended package manager

### Linux
- Uses `xclip` or `wl-clipboard` for clipboard (auto-detected)
- Uses `xdg-open` for file/URL opening
- Package names may vary by distribution

### Windows (WSL)
- Functions should work in WSL environment
- Clipboard integration may require additional setup
- Uses `start` for file/URL opening

## Updating

```bash
cd academic-workflow-tools
git pull
cd functions
nu install.nu
```

## Uninstalling

```bash
# Remove individual functions
rm ~/.local/bin/fcit ~/.local/bin/fcitz ~/.local/bin/fwl ~/.local/bin/fsem ~/.local/bin/fsh ~/.local/bin/fsearch

# Or remove entire directory
rm -rf academic-workflow-tools/
```