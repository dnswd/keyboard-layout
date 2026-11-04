keymap_name := "dnswd_custom_keymap"

set shell := ["bash", "-c"]

# Default action is to list all available keyboard layouts
default: list

# List all custom keyboard layouts found in this monorepo
list:
    @find . -name keymap.c | sed -E 's|^\./(.*)/keymap.c|\1|'

# Compile one or all keyboard layouts. Usage: `just compile` or `just compile beekeeb/piantor_pro`
compile keyboard="all":
    #!/usr/bin/env bash
    set -euo pipefail
    qmk_home=$(qmk env 2>/dev/null | grep QMK_HOME | cut -d'"' -f2 || qmk env 2>/dev/null | grep QMK_HOME | cut -d'"' -f2 || echo "$HOME/qmk_firmware")
    
    if [ -z "$qmk_home" ]; then
        echo "Error: Could not resolve QMK_HOME." >&2
        exit 1
    fi

    if [ "{{keyboard}}" = "all" ]; then
        keyboards=$(find . -name keymap.c | sed -E 's|^\./(.*)/keymap.c|\1|')
        for kb in $keyboards; do
            echo "=========================================================="
            echo "Compiling $kb..."
            echo "=========================================================="
            mkdir -p "$qmk_home/keyboards/$kb/keymaps"
            ln -sfn "$PWD/$kb" "$qmk_home/keyboards/$kb/keymaps/{{keymap_name}}"
            qmk compile -kb "$kb" -km {{keymap_name}}
        done
    else
        kb="{{keyboard}}"
        if [ ! -f "$kb/keymap.c" ]; then
            echo "Error: Keyboard layout folder '$kb' not found or does not contain keymap.c" >&2
            exit 1
        fi
        echo "=========================================================="
        echo "Compiling $kb..."
        echo "=========================================================="
        mkdir -p "$qmk_home/keyboards/$kb/keymaps"
        ln -sfn "$PWD/$kb" "$qmk_home/keyboards/$kb/keymaps/{{keymap_name}}"
        qmk compile -kb "$kb" -km {{keymap_name}}
    fi

# Compile and Flash one or all keyboard layouts. Usage: `just flash` or `just flash beekeeb/piantor_pro`
flash keyboard="all":
    #!/usr/bin/env bash
    set -euo pipefail
    qmk_home=$(qmk env 2>/dev/null | grep QMK_HOME | cut -d'"' -f2 || qmk env 2>/dev/null | grep QMK_HOME | cut -d'"' -f2 || echo "$HOME/qmk_firmware")
    
    if [ -z "$qmk_home" ]; then
        echo "Error: Could not resolve QMK_HOME." >&2
        exit 1
    fi

    if [ "{{keyboard}}" = "all" ]; then
        keyboards=$(find . -name keymap.c | sed -E 's|^\./(.*)/keymap.c|\1|')
        for kb in $keyboards; do
            echo "=========================================================="
            echo "Flashing $kb..."
            echo "=========================================================="
            mkdir -p "$qmk_home/keyboards/$kb/keymaps"
            ln -sfn "$PWD/$kb" "$qmk_home/keyboards/$kb/keymaps/{{keymap_name}}"
            qmk flash -kb "$kb" -km {{keymap_name}}
        done
    else
        kb="{{keyboard}}"
        if [ ! -f "$kb/keymap.c" ]; then
            echo "Error: Keyboard layout folder '$kb' not found or does not contain keymap.c" >&2
            exit 1
        fi
        echo "=========================================================="
        echo "Flashing $kb..."
        echo "=========================================================="
        mkdir -p "$qmk_home/keyboards/$kb/keymaps"
        ln -sfn "$PWD/$kb" "$qmk_home/keyboards/$kb/keymaps/{{keymap_name}}"
        qmk flash -kb "$kb" -km {{keymap_name}}
    fi

# Interactively choose a keyboard to compile or flash using fzf. Usage: `just choose` or `just choose flash`
choose action="compile":
    #!/usr/bin/env bash
    set -euo pipefail
    keyboards=$(find . -name keymap.c | sed -E 's|^\./(.*)/keymap.c|\1|')
    if [ -z "$keyboards" ]; then
        echo "No keyboards found in the monorepo!" >&2
        exit 1
    fi
    selected=$(echo "$keyboards" | fzf --prompt "Select keyboard to {{action}}: " --height 40% --reverse)
    if [ -n "$selected" ]; then
        just {{action}} "$selected"
    fi

# Clean up build artifacts and remove symlinks in QMK_HOME
clean:
    #!/usr/bin/env bash
    set -euo pipefail
    qmk_home=$(qmk env 2>/dev/null | grep QMK_HOME | cut -d'"' -f2 || qmk env 2>/dev/null | grep QMK_HOME | cut -d'"' -f2 || echo "$HOME/qmk_firmware")
    echo "Cleaning up QMK build artifacts..."
    qmk clean || true
    
    echo "Cleaning up symlinks in QMK_HOME..."
    keyboards=$(find . -name keymap.c | sed -E 's|^\./(.*)/keymap.c|\1|')
    for kb in $keyboards; do
        symlink="$qmk_home/keyboards/$kb/keymaps/{{keymap_name}}"
        if [ -L "$symlink" ]; then
            echo "Removing symlink: $symlink"
            rm "$symlink"
        fi
    done
