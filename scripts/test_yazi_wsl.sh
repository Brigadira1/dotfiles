#!/bin/bash

echo "==================================="
echo "Testing Yazi Configuration in WSL"
echo "==================================="
echo

# Check if in WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "✓ Running in WSL"
else
    echo "✗ Not running in WSL"
    echo "Please run: wsl -d Arch"
    exit 1
fi

# Check yazi installation
if command -v yazi &>/dev/null; then
    echo "✓ Yazi is installed: $(which yazi)"
else
    echo "✗ Yazi not found. Install with: sudo pacman -S yazi"
    exit 1
fi

# Check config
if [ -f ~/.config/yazi/yazi.toml ]; then
    echo "✓ Yazi config found: ~/.config/yazi/yazi.toml"
else
    echo "✗ Yazi config not found"
    exit 1
fi

# Check nvim
if command -v nvim &>/dev/null; then
    echo "✓ Neovim is installed: $(which nvim)"
else
    echo "✗ Neovim not found. Install with: sudo pacman -S neovim"
fi

# Check file command (for mime detection)
if command -v file &>/dev/null; then
    echo "✓ File utility found: $(which file)"
else
    echo "✗ File utility not found. Install with: sudo pacman -S file"
fi

echo
echo "==================================="
echo "Opening yazi in test mode..."
echo "==================================="
echo "Press 'q' to quit"
echo "Press 'Enter' on a .md file to open with nvim"
echo

# Create a test markdown file
TEST_FILE="/tmp/test_yazi.md"
cat > "$TEST_FILE" << 'EOF'
# Yazi Test File

This is a test markdown file.

## Testing Features:
- File preview
- Opening with nvim
- Navigation

Press 'Enter' to open this file with nvim in yazi.
EOF

echo "Created test file: $TEST_FILE"
echo

# Start yazi in the temp directory
cd /tmp
yazi
