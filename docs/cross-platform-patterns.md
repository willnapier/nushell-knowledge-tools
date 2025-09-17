# Cross-Platform Patterns in Nushell

This document outlines common patterns for writing cross-platform Nushell code that works seamlessly across macOS, Linux, and Windows.

## Platform Detection

### Basic Platform Detection
```nushell
if $nu.os-info.name == "macos" {
    # macOS-specific code
    print "Running on macOS"
} else if $nu.os-info.name == "linux" {
    # Linux-specific code
    print "Running on Linux"
} else if $nu.os-info.name == "windows" {
    # Windows-specific code
    print "Running on Windows"
} else {
    print $"Unknown platform: ($nu.os-info.name)"
}
```

### Platform-Specific Tool Selection
```nushell
def get-clipboard-command [] {
    if $nu.os-info.name == "macos" {
        "pbcopy"
    } else if $nu.os-info.name == "linux" {
        if (which wl-copy | is-not-empty) {
            "wl-copy"  # Wayland
        } else {
            "xclip"    # X11
        }
    } else if $nu.os-info.name == "windows" {
        "clip"
    } else {
        error make {msg: "Unsupported platform for clipboard operations"}
    }
}
```

## Tool Availability Checking

### Single Tool Check
```nushell
if (which tool-name | is-not-empty) {
    ^tool-name $args
} else {
    print "❌ Install tool-name: package-manager install tool-name"
}
```

### Multiple Tool Fallback
```nushell
def find-available-tool [tools: list<string>] {
    $tools | where {|tool| which $tool | is-not-empty} | get -o 0?
}

# Usage
let clipboard_tool = find-available-tool ["wl-copy", "xclip", "xsel"]
if ($clipboard_tool | is-not-empty) {
    $text | ^$clipboard_tool
} else {
    print "No clipboard tool found"
}
```

## Graceful Degradation

### Clipboard Operations with Fallback
```nushell
def cross-platform-clipboard-copy [] {
    let input = $in

    if $nu.os-info.name == "macos" {
        $input | ^pbcopy
    } else if $nu.os-info.name == "linux" {
        if (which wl-copy | is-not-empty) {
            $input | ^wl-copy
        } else if (which xclip | is-not-empty) {
            $input | ^xclip -selection clipboard
        } else if (which xsel | is-not-empty) {
            $input | ^xsel --clipboard --input
        } else {
            print "❌ No clipboard tool found"
            print "Install: sudo apt install wl-clipboard xclip"
            return
        }
    } else if $nu.os-info.name == "windows" {
        $input | ^clip
    } else {
        print $"❌ Unsupported platform: ($nu.os-info.name)"
        return
    }

    print "✅ Copied to clipboard"
}
```

### File Opening with Platform Detection
```nushell
def open-file [file: string] {
    if not ($file | path exists) {
        error make {msg: $"File not found: ($file)"}
    }

    match $nu.os-info.name {
        "macos" => { ^open $file }
        "linux" => { ^xdg-open $file }
        "windows" => { ^start $file }
        _ => {
            print $"❌ Cannot open files on ($nu.os-info.name)"
            print $"Manual action: Open ($file)"
        }
    }
}
```

## Path Handling

### Cross-Platform Path Construction
```nushell
def get-config-dir [] {
    if $nu.os-info.name == "windows" {
        $env.APPDATA
    } else {
        $env.HOME | path join ".config"
    }
}

def get-app-config-path [app_name: string] {
    get-config-dir | path join $app_name
}
```

### Home Directory Paths
```nushell
# Always use $env.HOME, never hardcode paths
def get-user-file [filename: string] {
    $env.HOME | path join $filename
}

# Good: Cross-platform
let notes_dir = $env.HOME | path join "Documents" "Notes"

# Bad: Platform-specific
let notes_dir = "/Users/username/Documents/Notes"  # macOS only
```

## Environment Variables

### Platform-Specific Defaults
```nushell
def get-editor [] {
    $env.EDITOR? | default (
        if $nu.os-info.name == "windows" {
            "notepad"
        } else {
            "nano"
        }
    )
}
```

### PATH Handling
```nushell
def add-to-path [new_path: string] {
    let separator = if $nu.os-info.name == "windows" { ";" } else { ":" }
    let current_path = $env.PATH | str join $separator

    if not ($current_path | str contains $new_path) {
        $env.PATH = ($env.PATH | append $new_path)
    }
}
```

## Error Handling

### Informative Error Messages
```nushell
def try-platform-command [commands: record] {
    let platform = $nu.os-info.name

    if ($platform in $commands) {
        let cmd = $commands | get $platform
        try {
            ^$cmd.command ...$cmd.args
        } catch {|err|
            print $"❌ Command failed on ($platform): ($cmd.command)"
            print $"Install: ($cmd.install_hint)"
        }
    } else {
        print $"❌ Platform ($platform) not supported"
        print $"Supported: ($commands | columns | str join ', ')"
    }
}

# Usage
try-platform-command {
    macos: {command: "pbcopy", args: [], install_hint: "Pre-installed"}
    linux: {command: "xclip", args: ["-selection", "clipboard"], install_hint: "sudo apt install xclip"}
    windows: {command: "clip", args: [], install_hint: "Pre-installed"}
}
```

## Testing Cross-Platform Code

### Platform Simulation for Testing
```nushell
def test-on-platform [platform: string, code: closure] {
    # Note: This is conceptual - Nushell doesn't allow runtime platform change
    print $"Testing behavior on ($platform):"

    # Simulate platform-specific behavior
    match $platform {
        "macos" => { print "Would use: pbcopy, open, AppleScript" }
        "linux" => { print "Would use: xclip/wl-copy, xdg-open, xdotool" }
        "windows" => { print "Would use: clip, start, PowerShell" }
    }
}
```

### Comprehensive Platform Support Check
```nushell
def check-platform-support [] {
    print $"Platform: ($nu.os-info.name)"
    print $"Architecture: ($nu.os-info.arch)"

    let tools = [
        {name: "clipboard", macos: "pbcopy", linux: ["wl-copy", "xclip"], windows: "clip"}
        {name: "file_opener", macos: "open", linux: "xdg-open", windows: "start"}
    ]

    for tool in $tools {
        print $"Checking ($tool.name) support..."
        # Implementation would check tool availability
    }
}
```

## Best Practices

1. **Always use `$nu.os-info.name` for platform detection**
2. **Provide helpful installation messages for missing tools**
3. **Use `which` to check tool availability before calling**
4. **Prefer standard tools that exist across platforms**
5. **Gracefully degrade functionality when tools are missing**
6. **Use `$env.HOME` instead of hardcoded paths**
7. **Test on multiple platforms when possible**
8. **Document platform-specific requirements clearly**

These patterns enable creating Nushell tools that provide consistent interfaces while adapting to platform-specific implementations underneath.