#!/bin/bash

# Define the rules block
RULES_BLOCK=$(cat << 'EOF'
# Agent Optimization Rules

## Preferred Search Commands
- Always prioritize using `fd` over the standard `find` command when searching for files or directories in the filesystem.
- Always prioritize using `rg` (ripgrep) over the standard `grep` or `egrep` commands when searching for file content or patterns.

## Tool Preferences
- Use `bat` instead of `cat` for displaying files to view syntax-highlighted code.
- Use `eza` (with `--long --header --git`) instead of `ls` to list files with metadata and git status.
- Use `tldr` instead of `man` when looking up command options.

## Terminal Execution & Log Filtering
- Avoid commands that generate excessive output. Use `head` or `tail` to preview large files.
- When debugging executables or running processes with verbose logs, always pipe the output to `less` (for paging) or filter it using `grep` or `rg` to extract only relevant messages and prevent terminal/context bloat.
- Always use non-interactive flags (e.g., `npm install -y`, `apt-get install -y`) to prevent the shell from hanging on user input prompts.
- Avoid raw `git log` or `git diff` on large repositories; specify limits (e.g., `git log -n 5` or target specific files).

## File Exclusion
- When searching or indexing, exclude build artifacts, package dependencies (`node_modules`), virtual environments (`.venv`), and cache directories unless explicitly instructed.
EOF
)

# Files to update
FILES=(
  "$HOME/.gemini/config/AGENTS.md"
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.pi/agent/APPEND_SYSTEM.md"
  "$HOME/.pi/agent/AGENTS.md"
  "$HOME/.config/opencode/AGENTS.md"
)

# Update function
update_file() {
  local file="$1"
  local dir
  dir=$(dirname "$file")

  echo "Processing $file..."

  # Ensure directory exists
  mkdir -p "$dir"

  # Create file if it doesn't exist
  if [ ! -f "$file" ]; then
    echo "$RULES_BLOCK" > "$file"
    echo "Created and initialized $file."
    return
  fi

  # If it exists, check if the optimization rules are already added
  if grep -Fq "# Agent Optimization Rules" "$file" || grep -Fq "Always prioritize using \`fd\`" "$file"; then
    echo "Optimizations already present in $file. Skipping merge."
  else
    # Append with a couple of newlines
    echo -e "\n\n$RULES_BLOCK" >> "$file"
    echo "Merged optimizations into $file."
  fi
}

for file in "${FILES[@]}"; do
  update_file "$file"
done

echo "Initialization complete!"
