# fcit - Universal Citation Picker
# Part of nushell-knowledge-tools
# https://github.com/willnapier/nushell-knowledge-tools

# Universal citation picker - search and copy citation keys
# Works with academic research workflow (Zotero + BibTeX integration)
# Updated 2025-10-01: Clean output format without internal Zotero keys
export def main [] {
    print "🔍 Loading citations..."
    let citations_file = $"($env.FORGE?)/ZET/citations.md"
    if not ($citations_file | path exists) {
        print $"❌ Citations file not found: ($citations_file)"
        return
    }

    let citations = (open $citations_file | lines | where $it != "" | where ($it | str starts-with "#") == false | where ($it | str trim) != "")
    if ($citations | is-empty) {
        print "❌ No citations found"
        return
    }

    let selected = ($citations | str join "\n" | ^env TERM=xterm-256color TERMINFO="" TERMINFO_DIRS="" sk --preview 'echo {}' --bind 'up:up,down:down,ctrl-j:down,ctrl-k:up' --prompt "📚 Citation: " | str trim)
    if not ($selected | is-empty) {
        # Extract clean key and title, removing the [ZoteroKey] part
        # Format: "CleanKey [ZoteroKey] Title - keywords" → "CleanKey Title"
        let citation_text = ($selected | parse --regex '^([^\[]+)\[([^\]]+)\]\s*(.*)$' | get -o 0?)

        if not ($citation_text | is-empty) {
            let clean_key = ($citation_text.capture0 | str trim)
            let title_and_keywords = ($citation_text.capture2 | str trim)
            let readable_citation = $"($clean_key) ($title_and_keywords)"

            # Use cross-platform clipboard
            if (sys host | get name) == "Darwin" {
                $readable_citation | pbcopy
            } else if (which wl-copy | is-not-empty) {
                $readable_citation | wl-copy
            } else if (which xclip | is-not-empty) {
                $readable_citation | xclip -selection clipboard
            } else {
                print $"⚠️  No clipboard tool found. Citation: ($readable_citation)"
                return
            }

            print $"📋 Copied to clipboard: ($readable_citation)"
        } else {
            # Fallback: just copy the whole line if parsing fails
            if (sys host | get name) == "Darwin" {
                $selected | pbcopy
            } else if (which wl-copy | is-not-empty) {
                $selected | wl-copy
            } else if (which xclip | is-not-empty) {
                $selected | xclip -selection clipboard
            } else {
                print $"⚠️  No clipboard tool found. Citation: ($selected)"
                return
            }
            print $"📋 Copied to clipboard: ($selected)"
        }
        print "💡 Paste anywhere with Cmd+V (macOS) or Ctrl+V (Linux)"
    }
}

# USAGE:
# fcit                    # Open citation picker
#
# REQUIREMENTS:
# - sk (skim) fuzzy finder
# - citations.md file at $FORGE/ZET/citations.md
# - Clipboard tool: pbcopy (macOS), wl-copy or xclip (Linux)
#
# OUTPUT FORMAT:
# Zamoyski2009 Poland: A History
#
# The [ZoteroKey] is removed from output for clean, readable citations
# perfect for journal writing and note-taking.
