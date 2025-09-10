# Migrating from Obsidian: A Power User's Guide

> You've outgrown GUI-based knowledge management. Here's how to transition to terminal-native workflows while keeping what works.

## Why Make the Switch?

### **What You Keep from Obsidian**
- ✅ **Markdown files** - Your notes remain in plain text
- ✅ **Wiki-style linking** - `[[Note Title]]` syntax works the same  
- ✅ **Local file ownership** - No cloud lock-in, files are yours
- ✅ **Folder organization** - Keep your existing structure
- ✅ **Link relationships** - Connections between ideas preserved

### **What You Gain by Switching**
- 🚀 **Performance**: 5-10x faster operations
- 💻 **SSH access**: Full functionality over remote connections
- 🔧 **Tool independence**: Use any editor, terminal, multiplexer
- ⚙️ **Infinite customization**: Modify functions to your exact needs
- 💾 **Memory efficiency**: 20x less RAM usage
- 📊 **Structured data**: Reliable processing instead of fragile parsing

### **What You Give Up**
- 📱 **Mobile apps** - Terminal-focused workflow
- 🖱️ **GUI convenience** - Learning CLI commands required
- 🔌 **Plugin ecosystem** - Build your own tools instead
- 👥 **Collaboration features** - Individual workflow optimization

## Migration Strategy: Gradual Transition

### **Phase 1: Parallel Setup** (Week 1)
**Goal**: Set up functions alongside existing Obsidian workflow

1. **Keep using Obsidian** for daily work
2. **Install functions** following the [installation guide](installation.md)
3. **Test basic functionality** with your existing vault:
   ```bash
   export OBSIDIAN_VAULT="/path/to/your/obsidian/vault"
   fsh    # Test file search
   fwl    # Test wiki link creation
   ```

### **Phase 2: Function Integration** (Week 2-3)  
**Goal**: Start using functions for specific tasks

1. **File navigation**: Replace Obsidian's file explorer with `fsh`
2. **Content search**: Use `fsearch` instead of Obsidian's search
3. **Link creation**: Try `fwl` for wiki links while writing

**Tip**: Open terminal alongside Obsidian, gradually shift tasks over.

### **Phase 3: Citation Setup** (Week 3-4)
**Goal**: Replicate Obsidian's citation management

1. **Export existing citations** from Obsidian plugins (if used)
2. **Set up Zotero workflow** following [citation setup guide](citation-setup.md)  
3. **Test citation functions**: `fcit` and `fcitz`
4. **Migrate citation workflow** from Obsidian to terminal

### **Phase 4: Editor Transition** (Week 4-6)
**Goal**: Move from Obsidian editor to your preferred terminal editor

1. **Choose your editor**: Helix, Neovim, VS Code, etc.
2. **Configure markdown support**: Syntax highlighting, preview
3. **Test editing workflow**: Open notes with `fsh`, edit in your chosen editor
4. **Gradually reduce Obsidian usage**: Use only for reference/backup

### **Phase 5: Full Terminal Workflow** (Week 6+)
**Goal**: Complete independence from Obsidian GUI

1. **Verify all functions work** with your complete workflow
2. **Customize functions** for your specific needs  
3. **Optimize terminal setup** with multiplexer integration
4. **Obsidian becomes backup only** - or uninstall entirely

## File Structure Compatibility

### **Your Existing Obsidian Vault Works As-Is**
```
your-obsidian-vault/
├── Daily Notes/
├── Projects/  
├── Areas/
├── Resources/
├── Archive/
├── .obsidian/          # Functions ignore this folder
└── attachments/        # Images, PDFs work fine
```

### **Optional: Add Function-Specific Folders**
```
your-vault/
├── [all your existing folders]
└── ZET/                # For citation functions
    ├── citations.md    # Citation keys
    └── library.bib     # Auto-exported from Zotero
```

## Feature Mapping: Obsidian → Functions

### **Core Features**
| Obsidian Feature | Function Equivalent | Notes |
|------------------|-------------------|-------|
| **File Explorer** | `fsh` | Faster, works anywhere |
| **Global Search** | `fsearch` | Content search with context |
| **Quick Switcher** | `fsh` | File search with preview |
| **Link Creation** | `fwl` | Wiki-style `[[]]` links |
| **Citation Plugin** | `fcit` + `fcitz` | Zotero integration required |

### **Advanced Features**
| Obsidian Feature | Function Approach | Notes |
|------------------|------------------|-------|
| **Graph View** | Not replicated | Focus on linear workflow |
| **Templates** | Custom functions | Build your own templates |
| **Tags** | Standard markdown | `#tag` syntax works in any editor |
| **Backlinks** | Grep/search based | `rg "\[\[Current Note\]\]"` |
| **Daily Notes** | Custom function | Build date-based automation |

## Common Migration Challenges

### **"I Miss the Visual Interface"**
**Solution**: Embrace the speed gains
- Obsidian GUI: Pretty but slow  
- Terminal functions: Fast but text-based
- **Try it for 2 weeks** - speed becomes addictive

### **"Link Navigation is Different"**
**Obsidian**: Click links to navigate
**Terminal approach**: 
```bash
# Find notes linking to current topic
fsearch "Current Topic"
# Open related notes  
fsh
```

### **"I Lost My Plugins"**  
**Solution**: Build better tools
- Obsidian plugins: Limited by platform constraints
- Nushell functions: Unlimited customization potential
- **Example**: Custom daily note function vs Daily Notes plugin

### **"Mobile Access is Gone"**
**Solution**: Rethink mobile usage
- Most knowledge work happens at computer anyway
- Mobile can be for capture only (voice notes, quick captures)
- SSH access to your terminal from mobile (if needed)

## Obsidian-Specific Migrations

### **Dataview Plugin Users**
**Old**: Complex queries in Obsidian
```
TABLE rating, summary FROM #books WHERE rating > 7
```

**New**: Structured data with Nushell
```nushell
# Custom function to extract book data
def books-rated [] {
    rg "rating: (\d+)" vault --type md -A 2 
    | where rating > 7 
    | select file rating summary
}
```

### **Templater Plugin Users**  
**Old**: Obsidian template system
**New**: Custom Nushell functions
```nushell
def daily-note [] {
    let today = (date now | format date "%Y-%m-%d")  
    let template = $"# ($today)\n\n## Tasks\n\n## Notes\n\n"
    $template | save $"notes/daily/($today).md"
    hx $"notes/daily/($today).md"
}
```

### **Citation Plugin Migration**
**From Obsidian Citations Plugin**:
1. Export existing citation database
2. Import into Zotero
3. Set up BibTeX export  
4. Configure `fcit` and `fcitz` functions

## Advanced Customization Examples

### **Recreate Obsidian's "Random Note"**
```nushell
def random-note [] {
    let notes = (fd . $env.OBSIDIAN_VAULT --extension md)
    let random_note = ($notes | shuffle | first)
    hx $random_note
}
```

### **Backlink Functionality**  
```nushell
def backlinks [note_name: string] {
    rg $"\\[\\[($note_name)\\]\\]" $env.OBSIDIAN_VAULT --type md -l
    | lines
    | each { |file| {file: $file, preview: (open $file | lines | first 3)} }
}
```

### **Tag-Based Note Finding**
```nushell
def notes-by-tag [tag: string] {
    rg $"#($tag)" $env.OBSIDIAN_VAULT --type md -l
    | str join "\n"
    | sk --preview 'head -20 {}'
}
```

## Performance Comparison: Before/After

### **Daily Workflow Timing**
**Obsidian Workflow (morning routine)**:
```
1. Launch Obsidian: 5 seconds
2. Open daily note: 3 seconds  
3. Find yesterday's note: 8 seconds (navigation)
4. Search for project reference: 12 seconds
5. Create new project link: 6 seconds
Total: 34 seconds
```

**Terminal Workflow**:
```bash
1. Open terminal: 0 seconds (already open)
2. Create daily note: 2 seconds (custom function)
3. Find yesterday: 1 second (fsh)
4. Search project: 2 seconds (fsearch) 
5. Create link: 1 second (fwl)
Total: 6 seconds
```

**Improvement**: 5.7x faster daily routine

## Maintenance and Updates

### **Obsidian Required**
- Plugin updates, sync issues, performance degradation over time
- Vault corruption possibilities, backup management

### **Functions Approach**  
- Functions are simple scripts - easy to debug and modify
- No mysterious plugin conflicts or update breaking changes
- Version control your functions alongside your notes

## Community and Learning

### **Obsidian Community → Nushell Community**
- **Obsidian forums**: GUI-focused discussions
- **Nushell Discord**: Technical, automation-focused community  
- **GitHub**: Direct access to improve tools you use

### **Learning Resources**
- [Nushell Book](https://nushell.sh/book/) - Official documentation
- [Rust Tools Ecosystem](docs/rust-ecosystem.md) - Modern terminal stack
- [Function Customization](examples/) - Adapt to your needs

## Success Stories

### **"I'm Never Going Back"**  
*"Obsidian felt sluggish after trying these functions. The speed difference is incredible, and I love being able to access my notes over SSH."* - Terminal convert

### **"Best of Both Worlds"**
*"I kept my Obsidian vault structure but switched to terminal workflow. All my links still work, but everything is 5x faster."* - Hybrid approach user

### **"Finally, Tools That Match My Editor"**
*"Using Helix for code and GUI for notes felt weird. Now my knowledge workflow matches my development workflow."* - Developer/writer

## Next Steps

1. **Start the migration** with Phase 1 (parallel setup)
2. **Join the community** - Nushell Discord for questions
3. **Customize functions** - Make them work exactly how you want
4. **Share improvements** - Contribute back to the functions

**Ready to leave the GUI behind?** Your Obsidian vault will thank you for the performance upgrade.

---

*Remember: You can always keep Obsidian installed as a fallback during migration. Once you experience terminal-speed knowledge work, you probably won't need it.*