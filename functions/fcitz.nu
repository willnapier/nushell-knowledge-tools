#!/usr/bin/env nu
# File citation + open PDF in Zotero - Cross-platform PDF access from BibTeX library
# Searches library.bib for citations and opens corresponding PDFs

def main [] {
    print "🔍 Loading Zotero library..."
    let library_file = $"($env.OBSIDIAN_VAULT?)/ZET/library.bib"
    if not ($library_file | path exists) {
        print $"❌ Library file not found: ($library_file)"
        return
    }
    
    print "📚 Extracting citations from BibTeX library..."
    # Simple approach: extract keys, then get metadata for each
    let entries = (
        rg '@\w+\{([^,]+),' $library_file -o --replace '$1' --no-line-number
        | lines
        | uniq
        | each { |key|
            # Get the full entry for this key
            let entry_text = (rg -A 20 $"@\\w+\\{($key)," $library_file | str join ' ')
            
            # Extract title
            let title = (
                $entry_text 
                | parse --regex 'title\s*=\s*\{([^}]+(?:\{\{[^}]+\}\}[^}]+)*)\}' 
                | get -o 0.capture0? 
                | default ""
                | str replace --all '{{' '' 
                | str replace --all '}}' ''
            )
            
            # Extract file path
            let file_path = (
                $entry_text 
                | parse --regex 'file\s*=\s*\{([^}]+)\}' 
                | get -o 0.capture0? 
                | default ""
            )
            
            # Extract author
            let author = (
                $entry_text 
                | parse --regex 'author\s*=\s*\{([^}]+)\}' 
                | get -o 0.capture0? 
                | default ""
                | split row ' and ' 
                | get -o 0? 
                | default ""
                | split row ',' 
                | get -o 0? 
                | default ""
            )
            
            # Extract year  
            let year = (
                $entry_text 
                | parse --regex 'year\s*=\s*\{(\d+)\}' 
                | get -o 0.capture0? 
                | default ""
            )
            
            # Create display string
            let display = if ($title | is-empty) {
                $key
            } else if (not ($author | is-empty)) and (not ($year | is-empty)) {
                $"($key) | ($author) (($year)) - ($title)"
            } else if not ($year | is-empty) {
                $"($key) | (($year)) - ($title)"
            } else {
                $"($key) | ($title)"
            }
            
            {key: $key, title: $title, file: $file_path, display: $display}
        }
    )
    
    if ($entries | is-empty) {
        print "❌ No citations found in library.bib"
        return
    }
    
    print $"📖 Found (($entries | length)) entries"
    
    # Create selection list
    let selected = (
        $entries 
        | get display 
        | str join "\n" 
        | ^env TERM=xterm-256color TERMINFO="" TERMINFO_DIRS="" sk 
            --preview 'echo {}' 
            --bind 'up:up,down:down,ctrl-j:down,ctrl-k:up' 
            --prompt "📚 Citation → PDF: " 
        | str trim
    )
    
    if not ($selected | is-empty) {
        # Find the matching entry
        let entry = ($entries | where { |it| $it.display == $selected } | get -o 0?)
        
        if ($entry | is-empty) {
            print "❌ Could not find entry data"
            return
        }
        
        print $"📄 Opening: ($entry.key)"
        
        # Try to open the PDF file directly if available
        if (not ($entry.file | is-empty)) and ($entry.file | path exists) {
            print $"📂 Opening PDF: ($entry.file | path basename)"
            
            # Cross-platform file opening
            let open_cmd = if $nu.os-info.name == "macos" {
                "open"
            } else if $nu.os-info.name == "linux" {
                "xdg-open"
            } else {
                "start"  # Windows
            }
            ^$open_cmd $entry.file
            print "✅ PDF opened directly"
        } else {
            # Fallback to Zotero select URL to highlight the item
            print "🔍 Opening in Zotero library (PDF not found locally)..."
            
            # Use the select URL scheme which works better than search
            # This will select the item in Zotero, then user can double-click to open PDF
            let zotero_url = $"zotero://select/items/@($entry.key)"
            
            # Cross-platform URL opening
            let open_cmd = if $nu.os-info.name == "macos" {
                "open"
            } else if $nu.os-info.name == "linux" {
                "xdg-open"
            } else {
                "start"  # Windows
            }
            ^$open_cmd $zotero_url
            
            print "💡 Item selected in Zotero - double-click to open its PDF"
            print $"💡 If not found, try searching for: ($entry.title)"
        }
    }
}