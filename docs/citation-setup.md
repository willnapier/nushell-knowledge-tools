# Citation Workflow Setup Guide

> Complete setup instructions for `fcit` and `fcitz` functions - from Zotero to command line

## Overview

The citation functions (`fcit` and `fcitz`) provide lightning-fast access to your research library, but require initial setup of:
1. **Zotero** for reference management
2. **BibTeX export** for structured data access  
3. **Citation curation** for streamlined workflow
4. **File structure** that matches function expectations

**Time investment**: 30-60 minutes initial setup
**Ongoing maintenance**: 5-10 minutes per month

## Prerequisites

### Required Software
- [Zotero](https://www.zotero.org/) (free reference manager)
- [Better BibTeX](https://retorque.re/zotero-better-bibtex/) plugin for Zotero
- Nushell (obviously, for the functions)

### Recommended Setup
- Existing markdown-based knowledge system (Obsidian vault, Foam workspace, or plain markdown folder)
- Collection of academic PDFs or research materials

## Step 1: Zotero Setup

### Install Zotero
```bash
# macOS
brew install --cask zotero

# Linux (download from website)
wget https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64
```

### Install Better BibTeX Plugin
1. Download from https://retorque.re/zotero-better-bibtex/
2. In Zotero: Tools → Add-ons → Install Add-on from File
3. Select the downloaded `.xpi` file
4. Restart Zotero

### Configure Better BibTeX
1. Zotero → Preferences → Better BibTeX
2. **Citation keys**: Set format (default is usually fine)
3. **Export**: Check "Export unicode as plain-text latex commands"
4. **Automatic export**: Enable for real-time sync

## Step 2: Build Your Reference Library

### Import References
**From PDFs:**
1. Drag PDFs into Zotero
2. Zotero automatically extracts metadata
3. Review and clean up entries

**From DOIs/URLs:**  
1. Use Zotero browser connector
2. One-click import from academic sites
3. Automatic PDF download when available

**From existing bibliographies:**
1. Import BibTeX, RIS, or other formats
2. File → Import → Select format

### Organize Your Library
**Recommended structure:**
```
📁 My Library
├── 📁 Active Projects
│   ├── 📁 Current Paper
│   └── 📁 Knowledge Work
├── 📁 By Topic
│   ├── 📁 Productivity
│   ├── 📁 Psychology  
│   └── 📁 Technology
└── 📁 Archive
```

## Step 3: Export Configuration

### Set Up Automatic BibTeX Export
1. Right-click your library root or collection
2. "Export Library/Collection..."
3. Format: "Better BibTeX"
4. Check "Keep updated" (crucial for live sync)
5. Save as `library.bib` in your vault's `ZET` folder

**Target path**: `$OBSIDIAN_VAULT/ZET/library.bib`

### Verify Export
Check that your `library.bib` contains entries like:
```bibtex
@article{smith2024automation,
  title={Automation in Knowledge Work},
  author={Smith, John},
  journal={Productivity Review},
  year={2024},
  file={/path/to/smith_2024_automation.pdf}
}
```

## Step 4: Create Citations Database

### Manual Approach (Recommended for Start)
Create `$OBSIDIAN_VAULT/ZET/citations.md`:
```markdown
# Citations Database

@smith2024automation
@brown2023habits
@jones2022systems
@wilson2024tools
@garcia2023productivity
```

### Automated Approach (Advanced)
Extract citation keys automatically:
```bash
# Create citations.md from library.bib
rg '@\w+\{([^,]+),' library.bib -o --replace '$1' --no-line-number > citations.md
```

## Step 5: File Structure Setup

### Required Directory Structure
```
your-vault/
├── ZET/
│   ├── citations.md      # Citation keys database
│   └── library.bib       # Auto-exported from Zotero
└── [your notes and folders]
```

### Environment Variables
```bash
# Add to your shell config (~/.config/nushell/env.nu)
$env.OBSIDIAN_VAULT = "/path/to/your/vault"
```

## Step 6: Test the Functions

### Test Citation Picker
```bash
fcit
# Should show interactive picker with all your citations
```

**Troubleshooting:**
- "Citations file not found" → Check `citations.md` path
- "No citations found" → Verify file has citation keys (one per line)
- "Empty picker" → Check file permissions and content

### Test PDF Opener  
```bash
fcitz
# Should show picker with citation metadata and open PDFs
```

**Troubleshooting:**
- "Library file not found" → Check `library.bib` export location
- "PDF not found" → Verify Zotero file paths are absolute
- "No PDFs open" → Check file associations and permissions

## Workflow Integration

### Daily Research Workflow
```bash
# 1. Add new references to Zotero (browser, drag PDFs)
# 2. Let Better BibTeX auto-update library.bib
# 3. Periodically update citations.md (manual or script)
# 4. Use functions seamlessly:

fcit    # Quick citation insertion
fcitz   # Citation + PDF access
```

### Maintenance Tasks

**Weekly** (5 minutes):
- Clean up Zotero entries (duplicates, metadata)
- Update citation keys in citations.md

**Monthly** (10 minutes):  
- Review auto-export settings
- Backup library.bib
- Archive old/unused references

## Advanced Configuration

### Custom Citation Key Format
In Zotero → Preferences → Better BibTeX:
```
[auth:lower][year]  # → smith2024
[auth:lower][year][title:lower:select,1,1]  # → smith2024automation
```

### Automated Citations Update
Create script to sync citations.md with library.bib:
```bash
#!/usr/bin/env nu
# Update citations from library
rg '@\w+\{([^,]+),' $"($env.OBSIDIAN_VAULT)/ZET/library.bib" -o --replace '$1' --no-line-number | save -f $"($env.OBSIDIAN_VAULT)/ZET/citations.md"
```

### Integration with Note Templates
Template for research notes:
```markdown
---
date: {{date}}
source: @CITATIONKEY
---

# {{title}}

## Summary

## Key Points

## Connections
- [[Related Note]]

## Citation
@CITATIONKEY
```

## Troubleshooting Common Issues

### "File not found" errors
1. Verify `$env.OBSIDIAN_VAULT` is set correctly
2. Check that `ZET/` directory exists
3. Confirm file permissions are readable

### Empty citation picker
1. Check `citations.md` has content (one citation key per line)
2. Verify no extra whitespace or formatting
3. Test with a simple example file

### PDF files not opening
1. Check Zotero file paths are absolute (not relative)
2. Verify PDF files exist at specified locations
3. Test file associations with your system's default PDF viewer

### Better BibTeX export issues
1. Confirm plugin is installed and enabled
2. Check auto-export is configured and active
3. Try manual re-export to test

### Performance with large libraries
- Citation picker handles 1000+ entries well
- Consider splitting very large libraries into collections
- Use Zotero's search and tagging for organization

## Migration from Other Tools

### From Mendeley
1. Export library as BibTeX from Mendeley
2. Import into Zotero (File → Import)
3. Reattach PDF files if needed
4. Follow setup steps above

### From EndNote
1. Export as BibTeX or RIS format
2. Import into Zotero
3. Clean up citation keys and metadata
4. Follow setup steps above

### From Plain BibTeX Files
1. Import existing .bib file into Zotero
2. Configure Better BibTeX for consistent keys
3. Set up auto-export as described above

## Next Steps

Once your citation workflow is set up:
1. **Integrate with writing**: Use `fcit` while drafting
2. **Research efficiently**: Use `fcitz` to access sources quickly  
3. **Build connections**: Link citations to your note-taking system
4. **Customize further**: Adapt functions to your specific needs

The initial investment in setup pays dividends in daily research efficiency. Your citation workflow becomes as fast as your thinking.