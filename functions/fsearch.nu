#!/usr/bin/env nu
# File content search - Universal text discovery across vault
# Cross-platform content search with preview and clipboard copy

def main [] {
    if not ($env.OBSIDIAN_VAULT? | is-empty) and ($env.OBSIDIAN_VAULT | path exists) {
        let query = (input "🔍 Search content: ")
        if ($query | is-empty) {
            return
        }
        
        print $"🔍 Searching for: ($query)"
        let results = try {
            ^rg -i --type md -l $query $env.OBSIDIAN_VAULT | lines | where $it != ""
        } catch {
            print "❌ Content search failed. Install ripgrep: brew install ripgrep"
            return
        }
        
        if ($results | is-empty) {
            print "❌ No matches found"
            return
        }
        
        let selected = ($results | str join "\n" | ^env TERM=xterm-256color TERMINFO="" TERMINFO_DIRS="" sk --preview $"rg --color=always -i -C 3 '($query)' {}" --preview-window 'right:60%' --bind 'up:up,down:down,ctrl-j:down,ctrl-k:up' --prompt "📄 Content: " | str trim)
        if not ($selected | is-empty) {
            let filename = ($selected | path basename | str replace ".md" "")
            let wikilink = $"[[($filename)]]"
            $wikilink | pbcopy
            print $"📋 Copied to clipboard: ($wikilink)"
            print "💡 Paste anywhere with Cmd+V"
        }
    } else {
        print "❌ OBSIDIAN_VAULT not set or doesn't exist"
        print "💡 Set with: $env.OBSIDIAN_VAULT = '/path/to/your/vault'"
    }
}