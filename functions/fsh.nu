#!/usr/bin/env nu
# File search and open in editor - Universal file discovery
# Cross-platform file search with preview and editor integration

def main [] {
    if (which fd | is-empty) or (which sk | is-empty) {
        print "❌ Required tools missing."
        print "💡 Install with: brew install fd sk  # macOS"
        print "💡 Or: apt install fd-find skim  # Linux"
        return
    }
    let file = (fd . --type f --hidden --exclude .git | ^env TERM=xterm-256color TERMINFO="" TERMINFO_DIRS="" sk --preview 'bat --color=always {}' --preview-window 'right:60%' --bind 'up:up,down:down,ctrl-j:down,ctrl-k:up' --prompt "📁 File Search: " | str trim)
    if not ($file | is-empty) {
        print $"🚀 Opening ($file) in editor..."
        
        # Try to use configured editor, fallback to common ones
        let editor = if (not ($env.EDITOR? | is-empty)) {
            $env.EDITOR
        } else if (which hx | is-not-empty) {
            "hx"
        } else if (which nvim | is-not-empty) {
            "nvim"
        } else if (which vim | is-not-empty) {
            "vim"
        } else if (which code | is-not-empty) {
            "code"
        } else {
            print "❌ No editor found. Set $env.EDITOR or install hx/nvim/vim"
            return
        }
        
        ^$editor $file
    }
}