#!/usr/bin/env nu
# File wiki link picker - Universal knowledge navigation with clipboard copy
# Works across platforms for Obsidian vault navigation

def main [] {
    if not ($env.OBSIDIAN_VAULT? | is-empty) and ($env.OBSIDIAN_VAULT | path exists) {
        let file = (fd . $env.OBSIDIAN_VAULT --type f --extension md | ^env TERM=xterm-256color TERMINFO="" TERMINFO_DIRS="" sk --preview 'bat --color=always {}' --preview-window 'right:60%' --bind 'up:up,down:down,ctrl-j:down,ctrl-k:up' --prompt "📝 Wiki Link: " | str trim)
        if not ($file | is-empty) {
            let filename = ($file | path basename | str replace ".md" "")
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