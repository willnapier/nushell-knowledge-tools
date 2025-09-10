#!/usr/bin/env nu
# File semantic search - AI-powered concept discovery with clipboard copy
# Requires OPENAI_API_KEY and semantic-indexer setup

def main [] {
    if ($env.OPENAI_API_KEY? | is-empty) {
        print "❌ OPENAI_API_KEY not set for semantic search"
        print "💡 Set with: $env.OPENAI_API_KEY = 'your-api-key'"
        return
    }
    
    print "🧠 Semantic search in your vault..."
    let query = (input "🔍 Search concept: ")
    if ($query | is-empty) {
        return
    }
    
    print $"🔍 Finding notes related to: ($query)"
    let results = try {
        ^semantic-query --text $query --limit 20 2>/dev/null | lines | where $it != ""
    } catch {
        print "❌ Semantic search failed. Check if semantic-indexer is set up."
        print "💡 Run: semantic-status to check system configuration"
        return
    }
    
    if ($results | is-empty) {
        print "❌ No semantic matches found"
        return
    }
    
    let selected = ($results | str join "\n" | ^env TERM=xterm-256color TERMINFO="" TERMINFO_DIRS="" sk --preview 'bat --color=always {}' --preview-window 'right:60%' --bind 'up:up,down:down,ctrl-j:down,ctrl-k:up' --prompt "🧠 Semantic: " | str trim)
    if not ($selected | is-empty) {
        let filename = ($selected | path basename | str replace ".md" "")
        let wikilink = $"[[($filename)]]"
        $wikilink | pbcopy
        print $"📋 Copied to clipboard: ($wikilink)"
        print "💡 Paste anywhere with Cmd+V"
    }
}