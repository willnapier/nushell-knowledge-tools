#!/usr/bin/env nu
# Universal Academic Workflow Tools - Installation Script
# Cross-platform installer for Nushell academic functions

def main [--target-dir: string = "~/.local/bin"] {
    print "🚀 Installing Universal Academic Workflow Tools..."
    
    # Validate Nushell is available
    if (which nu | is-empty) {
        print "❌ Nushell not found. Install from: https://www.nushell.sh/"
        return
    }
    
    # Expand target directory
    let install_dir = ($target_dir | path expand)
    
    # Create target directory if it doesn't exist
    if not ($install_dir | path exists) {
        print $"📁 Creating directory: ($install_dir)"
        mkdir $install_dir
    }
    
    # List of functions to install
    let functions = ["fcit", "fcitz", "fwl", "fsem", "fsh", "fsearch"]
    
    print $"📦 Installing ($functions | length) functions to ($install_dir)..."
    
    # Install each function
    for func in $functions {
        let source = $"./($func).nu"
        let target = ($install_dir | path join $func)
        
        if ($source | path exists) {
            cp $source $target
            chmod +x $target
            print $"✅ Installed: ($func)"
        } else {
            print $"❌ Missing: ($source)"
        }
    }
    
    # Check if target directory is in PATH
    let path_dirs = ($env.PATH | split row (char esep))
    if not ($install_dir in $path_dirs) {
        print $"⚠️  Warning: ($install_dir) is not in your PATH"
        print $"💡 Add to your shell config:"
        print $"   $env.PATH = ($env.PATH | append '($install_dir)')"
    }
    
    print ""
    print "🎉 Installation complete!"
    print ""
    print "📋 Available commands:"
    for func in $functions {
        print $"  ($func) - (describe_function $func)"
    }
    print ""
    print "⚙️  Configuration needed:"
    print "  • Set $env.OBSIDIAN_VAULT to your vault path"
    print "  • For semantic search: Set $env.OPENAI_API_KEY"
    print "  • Ensure required tools are installed (fd, sk, rg, bat)"
}

def describe_function [name: string] {
    match $name {
        "fcit" => "Interactive citation picker",
        "fcitz" => "Citation + PDF opener",
        "fwl" => "Wiki link picker",
        "fsem" => "AI semantic search",
        "fsh" => "File search & open",
        "fsearch" => "Content search",
        _ => "Academic workflow function"
    }
}