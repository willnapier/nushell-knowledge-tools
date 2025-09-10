# Workflow Examples

## Academic Research Scenarios

### Scenario 1: Literature Review
You're working on a literature review and need to quickly access citations and PDFs.

```bash
# Find a citation for workflow automation
$ fcit
🔍 Loading citations...
[Interactive picker shows 447 entries]
# Type "workflow" to filter
# Select: @smith2024automation
📋 Copied to clipboard: @smith2024automation

# Now get the PDF for this citation
$ fcitz
📚 Citation → PDF: 
# Same search, but opens PDF directly
📂 Opening PDF: smith_2024_workflow_automation.pdf
✅ PDF opened directly
```

### Scenario 2: Cross-Referencing Notes
You remember writing about a concept but can't recall the exact note.

```bash
# Search for content about "structured data"
$ fsearch
🔍 Search content: structured data
🔍 Searching for: structured data
[Shows 12 matching files with context preview]
# Select the most relevant one
📋 Copied to clipboard: [[Data Processing Methods]]
# Paste into current note for cross-reference
```

### Scenario 3: Exploring Related Concepts
You want to discover notes related to your current research topic.

```bash
# AI-powered concept discovery
$ fsem
🧠 Semantic search in your vault...
🔍 Search concept: knowledge management
[AI finds conceptually related notes, not just keyword matches]
# Discovers: [[Information Architecture]], [[Cognitive Load Theory]]
📋 Copied to clipboard: [[Information Architecture]]
```

### Scenario 4: Remote Research Session
You're working on a colleague's machine or server with only terminal access.

```bash
# SSH into remote server
$ ssh research.university.edu

# Same workflow, same commands - everything works
$ fcit
📋 Copied: @johnson2023analysis

$ fwl  
📋 Copied: [[Research Methodology]]

# No GUI needed, no configuration required
```

## Cross-Platform Scenarios

### Scenario 5: macOS Development
Working on your local macOS machine:

```bash
$ fsh
[File picker opens with bat previews]
🚀 Opening paper_draft.md in Helix...
# Uses 'open' command and pbcopy for clipboard
```

### Scenario 6: Linux Server
Same workflow on Linux server:

```bash
$ fsh  
[Same interface, different backend]
🚀 Opening paper_draft.md in editor...
# Uses 'xdg-open' and xclip automatically
```

### Scenario 7: Windows WSL
Working in Windows Subsystem for Linux:

```bash
$ fsh
[Same interface, Windows integration]
🚀 Opening paper_draft.md in editor...
# Uses 'start' command, adapts to Windows clipboard
```

## Real-World Integration Examples

### Example 1: Writing Session
```bash
# Start daily writing session
$ daily-note  # Opens today's note

# While writing, need a citation
$ fcit
# Select citation, paste into note

# Need to reference related work
$ fwl
# Select related note, create wiki link

# Want to find similar concepts
$ fsem
# Discover related notes via AI
```

### Example 2: Paper Revision
```bash
# Find specific content to revise
$ fsearch
🔍 Search content: methodology section

# Get original sources
$ fcitz
# Open PDFs for fact-checking

# Link to supporting notes
$ fwl
# Create connections to background research
```

### Example 3: Collaborative Research
```bash
# Share exact commands with collaborator
"Just run 'fcit' and search for 'neural networks'"
"Use 'fwl' to get the link format for our shared vault"

# No setup instructions needed - works on any system
```

## Advanced Usage Patterns

### Chain Commands for Complex Workflows
```bash
# Research workflow: concept → citation → PDF
$ fsem      # Find related notes
$ fcit      # Get citation for found concept  
$ fcitz     # Open supporting PDF
```

### Integration with Text Editors
```bash
# From any editor that supports shell commands:
# In Helix: :pipe-to fwl  (creates wiki link for current selection)
# In Vim: :!fcit          (shows citation picker)
# In VS Code: terminal integration works seamlessly
```

### Bulk Operations
```bash
# Multiple citation lookups in sequence
$ fcit      # First citation
$ fcit      # Second citation  
$ fcit      # Third citation
# Each result goes to clipboard history
```

## Troubleshooting Examples

### Missing Dependencies
```bash
$ fsh
❌ Required tools missing.
💡 Install with: brew install fd sk  # macOS
💡 Or: apt install fd-find skim      # Linux

# After installation:
$ fsh
[Works immediately]
```

### Configuration Issues
```bash
$ fcit
❌ Citations file not found: /path/to/vault/ZET/citations.md
💡 Set OBSIDIAN_VAULT: $env.OBSIDIAN_VAULT = "/correct/path"

# After configuration:
$ fcit
🔍 Loading citations...
📚 Found 447 citations
```

### Platform Differences
```bash
# macOS
$ fwl
📋 Copied to clipboard: [[Note Title]]  # Uses pbcopy

# Linux  
$ fwl
📋 Copied to clipboard: [[Note Title]]  # Uses xclip/wl-copy

# Same user experience, different backend
```

## Performance Comparisons

### Traditional GUI Workflow
```
1. Open Zotero GUI (3-5 seconds)
2. Search for citation (10-30 seconds browsing)
3. Copy citation key (2 seconds)
4. Switch to editor (1 second)
5. Paste citation (1 second)
Total: ~17-39 seconds
```

### Universal CLI Workflow
```bash
$ fcit
[Interactive search opens immediately]
[Type few letters to filter]
[Select result]
📋 Copied to clipboard
Total: ~5-8 seconds (3-5x faster)
```

### Memory Usage
- **GUI approach**: Zotero (200MB+) + PDF viewer (50MB+) + Editor (30MB+)
- **CLI approach**: Terminal (5MB) + Editor (30MB) = 85% less memory

## Integration Examples

### With Existing Tools
```bash
# Combine with other CLI tools
$ fsh | xargs wc -l           # File search + line count
$ fsearch | xargs grep TODO   # Content search + TODO finding
```

### With Automation
```bash
# In scripts
for topic in "AI" "ML" "automation"; do
    echo "Researching: $topic"
    fsem <<< "$topic"
done
```

### With Keyboard Shortcuts (Optional)
```bash
# Can still use shortcuts if desired, but not required
# Terminal shortcut: Cmd+Shift+C → fcit
# Unlike before, this works in ANY terminal, not just configured ones
```

## Success Stories

### Research Team Adoption
"Our team went from spending 30 minutes explaining citation workflow setup to new members to: 'Run this one command.' Everyone gets the same tools instantly."

### Remote Work Transformation  
"Previously, working from home meant losing access to my carefully configured research environment. Now I have full functionality on any machine with just SSH access."

### Cross-Platform Collaboration
"Mac users, Linux users, and Windows users all use identical commands. No more platform-specific instructions in our documentation."

## Next Steps

After trying these examples:
1. Adapt the functions to your specific vault structure
2. Create custom functions for your unique workflows  
3. Share your methods with colleagues (just send the commands!)
4. Integrate with your existing development environment

The key insight: **Universal tools enable universal collaboration**. When methods work everywhere, knowledge sharing becomes effortless.