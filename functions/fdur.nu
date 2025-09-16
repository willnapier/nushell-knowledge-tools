#!/usr/bin/env nu

# fdur - Universal File Duration Processing
# Automatically calculates and inserts durations for activity time range entries
# Works anywhere with Nushell - no editor or terminal dependencies
# 
# Usage:
#   fdur                    # Process all .md files with time entries in current directory
#   fdur file.md           # Process specific file
#   fdur ~/notes/today.md  # Process file with absolute path
#
# Transforms entries like:
#   t:: meeting 0930-1015  →  t:: meeting 45min 0930-1015
#   s:: study 1400-1630    →  s:: study 2hr 30min 1400-1630
#
# Supports any activity prefix and handles arbitrary text content

def main [file_path?: string] {
    activity-duration-processor $file_path
}
