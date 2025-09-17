# Cross-Platform Academic Workflow Examples
# Demonstrates universal tool architecture in Nushell

# Universal clipboard function
def clipboard-copy [] {
    let input = $in
    if $nu.os-info.name == "macos" {
        $input | ^pbcopy
    } else if $nu.os-info.name == "linux" {
        if (which wl-copy | is-not-empty) {
            $input | ^wl-copy
        } else if (which xclip | is-not-empty) {
            $input | ^xclip -selection clipboard
        } else {
            print "❌ Install clipboard tool: sudo apt install wl-clipboard xclip"
        }
    } else if $nu.os-info.name == "windows" {
        $input | ^clip
    }
}

# Universal file opener
def open-file [file: string] {
    if $nu.os-info.name == "macos" {
        ^open $file
    } else if $nu.os-info.name == "linux" {
        ^xdg-open $file
    } else if $nu.os-info.name == "windows" {
        ^start $file
    }
}

# Academic citation browser (simplified example)
def citation-picker [] {
    # Read citations from BibTeX file (adjust path as needed)
    let citations = (
        try {
            open ~/library.bib
            | lines
            | where ($it | str contains "@")
            | parse --regex '@\w+\{([^,]+),'
            | get capture0
        } catch {
            ["example-citation-1", "example-citation-2", "example-citation-3"]
        }
    )

    # Interactive selection with fuzzy finder (requires sk/fzf)
    let selected = (
        $citations
        | str join "\n"
        | if (which sk | is-not-empty) {
            ^sk --prompt "📚 Citation: "
        } else {
            print "Install sk for interactive selection: brew install sk"
            $citations | get 0  # fallback to first item
        }
    )

    # Create markdown link and copy to clipboard
    let link = $"[[($selected)]]"
    $link | clipboard-copy
    print $"✅ Copied: ($link)"
}

# Cross-platform URL opener with Zotero integration example
def open-zotero-item [citation_key: string] {
    let zotero_url = $"zotero://select/items/@($citation_key)"

    # Open URL using platform-appropriate command
    if $nu.os-info.name == "macos" {
        ^open $zotero_url
    } else if $nu.os-info.name == "linux" {
        ^xdg-open $zotero_url
    } else if $nu.os-info.name == "windows" {
        ^start $zotero_url
    }

    print $"Opening Zotero item: ($citation_key)"
}

# Example usage:
# citation-picker      # Select citation → [[key]] copied to clipboard
# open-zotero-item "smith2023"  # Opens specific Zotero item