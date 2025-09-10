#!/usr/bin/env nu
# File citation picker - Interactive citation selector with clipboard copy
# Works universally across platforms and terminals

def main [] {
    print "🔍 Loading citations..."
    let citations_file = $"($env.OBSIDIAN_VAULT?)/ZET/citations.md"
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
        $selected | pbcopy
        print $"📋 Copied to clipboard: ($selected)"
        print "💡 Paste anywhere with Cmd+V"
    }
}