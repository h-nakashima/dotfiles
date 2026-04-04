#!/usr/bin/env bash
# run_once_migrate_zsh_history.sh
# Migrate Zsh history to Fish history format.
# Chezmoi will run this only once per machine.

set -e

FISH_HISTORY="$HOME/.local/share/fish/fish_history"
ZSH_HISTORY_ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs/.zsh_history"
ZSH_HISTORY_DEFAULT="$HOME/.zsh_history"

# Find the Zsh history file
if [ -f "$ZSH_HISTORY_ICLOUD" ]; then
    ZSH_HISTORY="$ZSH_HISTORY_ICLOUD"
elif [ -f "$ZSH_HISTORY_DEFAULT" ]; then
    ZSH_HISTORY="$ZSH_HISTORY_DEFAULT"
else
    echo "No Zsh history file found. Skipping migration."
    exit 0
fi

echo "Migrating Zsh history from: $ZSH_HISTORY"

mkdir -p "$(dirname "$FISH_HISTORY")"

# Backup existing Fish history if it exists
if [ -f "$FISH_HISTORY" ]; then
    cp "$FISH_HISTORY" "${FISH_HISTORY}.bak"
    echo "Backed up existing Fish history to ${FISH_HISTORY}.bak"
fi

python3 << PYTHON_EOF
import sys

META = 0x83
ZSH_HISTORY = """${ZSH_HISTORY}"""
FISH_HISTORY = """${FISH_HISTORY}"""

def decode_zsh_metafied(filepath):
    """Decode Zsh metafified binary file into a UTF-8 string."""
    with open(filepath, 'rb') as f:
        data = f.read()
    unmeta = bytearray()
    i = 0
    while i < len(data):
        b = data[i]
        if b == META:
            i += 1
            if i < len(data):
                unmeta.append(data[i] ^ 0x20)
        else:
            unmeta.append(b)
        i += 1
    return unmeta

def convert_to_fish(zsh_raw):
    """Convert Zsh extended history format to Fish YAML history format."""
    fish_entries = []
    current_timestamp = None
    current_cmd_lines = []

    # We must split the raw bytes by newline to handle encoding errors properly
    lines = zsh_raw.split(b'\n')

    for line_bytes in lines:
        # Decode each line, replacing bad bytes
        line = line_bytes.decode('utf-8', errors='replace')

        if line.startswith(': ') and ';' in line:
            # Flush previous entry
            if current_cmd_lines:
                cmd = '\n'.join(current_cmd_lines).strip()
                if cmd:
                    fish_entries.append((current_timestamp, cmd))
                current_cmd_lines = []
                current_timestamp = None

            try:
                # Format: `: timestamp:elapsed;command`
                prefix, cmd_part = line.split(';', 1)
                ts_part = prefix.strip().lstrip(': ').split(':')[0]
                current_timestamp = ts_part.strip()
                current_cmd_lines = [cmd_part]
            except Exception:
                current_cmd_lines = [line]
        else:
            # Continuation of a multi-line command
            if current_cmd_lines is not None:
                current_cmd_lines.append(line)
            elif line.strip():
                fish_entries.append((None, line.strip()))

    # Flush last entry
    if current_cmd_lines:
        cmd = '\n'.join(current_cmd_lines).strip()
        if cmd:
            fish_entries.append((current_timestamp, cmd))

    output = []
    for ts, cmd in fish_entries:
        output.append("- cmd: " + cmd)
        if ts:
            output.append("  when: " + ts)

    return '\n'.join(output) + '\n'

zsh_raw = decode_zsh_metafied(ZSH_HISTORY)
fish_text = convert_to_fish(zsh_raw)

with open(FISH_HISTORY, 'w', encoding='utf-8') as f:
    f.write(fish_text)

# Count entries
entry_count = fish_text.count('- cmd:')
print(f"Migration complete: {entry_count} commands imported to Fish history.")
PYTHON_EOF
