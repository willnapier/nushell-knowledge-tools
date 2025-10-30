# File Watcher Safety Guidelines

**Date**: 2025-10-30
**Status**: ✅ **CRITICAL REFERENCE** - Mandatory reading for file-modifying watchers
**Related**: [Critical Incident Report](https://github.com/willnapier/helix-knowledge-integration/blob/main/docs/critical-incident-2025-10-30.md)

---

## Executive Summary

File watchers that modify the files they watch require **mandatory debouncing** to prevent runaway loops. This document provides safety guidelines, testing protocols, and prevention measures based on a critical incident where missing debounce protection caused data corruption in 16 files.

**Core Rule**: Any script that watches files AND modifies those files MUST use debouncing with a minimum 2000ms delay.

---

## Critical Incident Reference (2025-10-30)

### What Happened

A Nushell-based wiki link management script (`wiki-resolve-mark`) was migrated from Python without understanding that Python's debouncing mechanism was a **critical safety feature**, not just an optimization. When the regex bug was fixed, the script immediately entered an infinite loop:

1. User edits file → Write event triggered
2. Script modifies file, adds `?[[` marker → Saves changes
3. Save triggers another Write event → Script processes again
4. Script adds another `?[[` marker → Infinite loop
5. Result: `????????????????????????????????[[Link]]` (thousands of duplicate markers)

**Files Affected**: 16 files corrupted with 2,000-7,780 duplicate link markers each
**Recovery**: Complete restoration from backup, comprehensive scan confirmed zero remaining corruption
**Root Cause**: Missing debounce protection when handling file modification events

### Key Lesson

**Understanding "Why" Over "What"**: When migrating code between languages, understand the architectural patterns that prevent bugs, not just the features that provide functionality. The Python script's debouncing wasn't an optimization—it was a **critical safety mechanism**.

---

## The Runaway Loop Anti-Pattern

### How It Happens

```nushell
# ❌ BROKEN: Self-triggering runaway loop
watch ~/Forge --glob "**/*.md" {|operation, file_path, new_path|
    match $operation {
        "Write" => {
            # Script modifies file
            let content = (open $file_path | str replace "[[" "?[[")
            $content | save -f $file_path
            # ^ This triggers another Write event!
            # → Infinite loop → Massive corruption
        }
    }
}
```

### Corruption Characteristics

**Normal file**: `[[Link Text]]` or `?[[Unresolved Link]]`
**Corrupted file**: `??????????????????[[Link Text]]` (many repeated `?` markers)
**Diagnostic**: Files with >1000 link markers are almost certainly corrupted

---

## The Solution: Debouncing

### How Debouncing Works

Debouncing creates a time window where repeated events for the same file are ignored:

1. User edits file → Write event triggered
2. Script processes file, modifies it → Saves changes
3. Save triggers another Write event
4. **Debounce barrier**: Event ignored because <2000ms since last processing
5. After 2000ms of quiet, script is ready for next legitimate edit

### Implementation Pattern

```nushell
# ✅ FIXED: Debounce prevents self-triggering
watch ~/Forge --glob "**/*.md" --debounce-ms 2000 {|operation, file_path, new_path|
    match $operation {
        "Write" => {
            # File was edited - mark new unresolved links
            # Debounce prevents self-triggering runaway loops
            handle_write $file_path $watch_paths
            # Script modifies file, but debounce window (2000ms)
            # prevents immediate re-trigger → No runaway loop!
        }
    }
}
```

---

## Mandatory Requirements

### Debounce Times

**File modification watchers**: Minimum 2000ms (2 seconds)
**Creation/deletion watchers**: Minimum 1000ms (1 second)

**Rationale**: Human edit cycles are >>2s, but script saves are <100ms. Debouncing creates a natural barrier that distinguishes between "user is actively editing" and "script is processing."

### Pre-Deployment Testing Protocol

For **any script that modifies files it watches**, follow this protocol before production:

```bash
# Mandatory testing before production
1. Create sandbox: mkdir ~/test-watcher && cd ~/test-watcher
2. Create test files with representative link counts
3. Start watcher with verbose logging
4. Perform typical user actions (edit, save, create, delete)
5. Monitor for self-triggering (check logs for rapid repeated events)
6. Verify file contents remain correct after multiple iterations
7. Load test: Edit file with highest expected link count
8. Time box: Run for 10 minutes minimum to catch delayed issues
```

**Critical Test**: Edit a file that the watcher processes, verify that:
- File is processed correctly
- No runaway loop occurs
- Performance is acceptable
- Monitor for 5+ minutes to catch slow-building issues

---

## Testing Methodology

### Integration Testing is Critical

**What We Tested**: Individual functions in isolation ✓
**What We Missed**: Full watch → modify → re-trigger cycle ✗

**Required Integration Test**:

```bash
# Sandbox testing protocol for file-modifying watchers
cd ~/test-watcher

# Create test file
echo "Test [[ExistingLink]] and [[NonExistentLink]]" > test.md

# Start watcher in background with logging
wiki-resolve-mark --debounce-ms 2000 > watcher.log 2>&1 &
WATCHER_PID=$!

# Modify the file (trigger Write event)
echo "" >> test.md

# Wait for processing
sleep 3

# Check for runaway loop indicators
count=$(grep -o "?\\[\\[" test.md | wc -l)
if [ $count -gt 10 ]; then
    echo "❌ RUNAWAY LOOP DETECTED: $count markers"
    kill $WATCHER_PID
    exit 1
fi

# Verify normal operation
if grep -q "?\\[\\[NonExistentLink\\]\\]" test.md; then
    echo "✅ Marking works correctly"
else
    echo "⚠️ Marking may not be working"
fi

# Stop watcher
kill $WATCHER_PID
```

### Performance vs. Corruption Diagnosis

**Observation**: "This file has 720 links - performance will be terrible!"
**Reality**: File had 16 links originally, 720+ from corruption

**Actual Link Distribution** (Post-Cleanup):
- 90% of files: <100 links
- 9% of files: 100-300 links
- 1% of files: 300-500 links
- 0% of files: >500 links (all corruption)

**Lesson**: Verify data integrity before optimizing for performance. Unusually high link counts may indicate corruption, not legitimate complexity.

---

## Corruption Detection & Recovery

### Automated Corruption Scanner

Create a weekly cron job to check for corrupted files:

```nushell
# Run weekly via cron
def check-vault-corruption [] {
    fd -t f ".md" ~/Forge ~/Admin
      | lines
      | each { |file|
          let count = (rg -c "\\[\\[" $file | into int)
          if $count > 1000 {
            print $"⚠️ CORRUPTED: ($file) has ($count) link markers"
          }
        }
}
```

### Recovery Procedure

If corruption is detected:

```bash
# 1. Stop the service immediately
link-service stop

# 2. Identify corrupted files
fd -t f ".md" ~/Forge ~/Admin | while IFS= read -r file; do
    count=$(rg -o "\\[\\[" "$file" | wc -l)
    if [ $count -gt 1000 ]; then
        echo "$file" >> /tmp/corrupted-files.txt
    fi
done

# 3. Restore from backup
while IFS= read -r file; do
    backup_file=$(find ~/.Trash/ForgeBackup_* -type f -name "$(basename "$file")" -print -quit)
    if [ -n "$backup_file" ]; then
        cp "$backup_file" "$file"
        echo "✅ Restored: $(basename "$file")"
    fi
done < /tmp/corrupted-files.txt

# 4. Verify recovery
# Run comprehensive scan to confirm zero remaining corruption
```

---

## Backup Best Practices

### Before Major Script Changes

```bash
# Create dated backup
rsync -av ~/Forge/ ~/.Trash/ForgeBackup_$(date +%Y-%m-%d)/
echo "✅ Backup created: ~/.Trash/ForgeBackup_$(date +%Y-%m-%d)/"

# Verify backup
backup_count=$(fd -t f ".md" ~/.Trash/ForgeBackup_$(date +%Y-%m-%d)/ | wc -l)
source_count=$(fd -t f ".md" ~/Forge/ | wc -l)
echo "Backup: $backup_count files | Source: $source_count files"
```

### Backup Verification

Always verify backup integrity:

1. Check file count matches source
2. Verify backup files are not corrupted (check link counts)
3. Test restoration of a sample file
4. Document backup location and date

---

## Design Patterns for Safety

### Simple Solutions Over Complex Ones

**Initial "Solution"**: Complex state file tracking system (~100 lines)
```nushell
# ❌ Overengineered approach
let state_file = "~/.cache/wiki-resolve-mark/modified-files.txt"
# Track every file modification
# Check state before processing
# Clean up state after processing
```

**Actual Solution**: Trust the existing debounce (0 new lines)
```nushell
# ✅ Correct approach
watch ~/Forge --debounce-ms 2000 {|op, file, new|
    # Debounce already prevents runaway - just use it!
}
```

**Lesson**: Question complexity - often the simple solution is already there.

### The Debugging Hierarchy

1. **Level 0**: Follow error messages (can miss root cause)
2. **Level 1**: Find patterns across errors (better but still symptomatic)
3. **Level 2**: Audit overall system state (often reveals root cause)
4. **Level 3**: Ask "What doesn't belong here?" (the breakthrough level)

**Remember**: Sometimes the best debugging is NOT following the error trail, but stepping back to see the whole picture.

---

## Checklist for File-Modifying Watchers

Before deploying any file watcher that modifies watched files:

- [ ] Debouncing enabled with minimum 2000ms delay
- [ ] Integration testing completed (watch → modify → re-trigger cycle)
- [ ] Sandbox testing for 10+ minutes minimum
- [ ] Backup created and verified
- [ ] Corruption scanner configured for monitoring
- [ ] Error handling for edge cases
- [ ] Logging configured for debugging
- [ ] Recovery procedure documented

---

## Related Documentation

- [wiki-link-management.md](./wiki-link-management.md) - Complete wiki link system architecture
- [CRITICAL-INCIDENT-WIKI-RESOLVE-MARK-RUNAWAY-BUG-2025-10-30.md](https://github.com/willnapier/helix-knowledge-integration/blob/main/docs/critical-incident-2025-10-30.md) - Detailed incident report

---

## Key Takeaways

1. **Debouncing is mandatory** for file-modifying watchers (minimum 2000ms)
2. **Integration testing is critical** - test the full watch → modify → re-trigger cycle
3. **Understand architectural patterns** when migrating code between languages
4. **Verify data integrity** before optimizing for performance
5. **Simple solutions are often best** - question complexity
6. **Always create backups** before deploying script changes

**When migrating code**: Understand the architectural patterns that prevent bugs, not just the features that provide functionality.

---

**Document Status**: ✅ Complete
**Last Updated**: 2025-10-30
**Incident Reference**: Wiki-Resolve-Mark Runaway Bug (16 files corrupted, full recovery achieved)
