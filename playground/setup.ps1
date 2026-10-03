#!/data/data/com.termux/files/usr/bin/bash

echo "Cleaning up old config..."
rm -f ~/.nanorc 2>/dev/null
rm -rf ~/.nano 2>/dev/null

echo "Installing/Updating nano..."
pkg update -y
pkg install nano wget -y

echo "Creating directories..."
mkdir -p ~/.nano/syntax ~/.nano/backups

echo "Downloading syntax files..."
cd ~/.nano/syntax

# Download syntax files that work
files=(
    "python.nanorc"
    "javascript.nanorc" 
    "bash.nanorc"
    "html.nanorc"
    "css.nanorc"
    "json.nanorc"
    "markdown.nanorc"
    "xml.nanorc"
    "c.nanorc"
    "cpp.nanorc"
)

for file in "${files[@]}"; do
    echo "  Downloading $file..."
    wget -q "https://raw.githubusercontent.com/scopatz/nanorc/master/$file" || echo "  Could not download $file"
done

echo "Creating Termux-compatible config..."
cat > ~/.nanorc << 'CONFIG'
## === NANO CONFIG FOR TERMUX ===

# Basic editing
set constantshow
set mouse
set tabsize 4
set tabstospaces
set multibuffer
set historylog
set backup
set backupdir ~/.nano/backups/

# Line numbers (works in most Termux versions)
set linenumbers

# Search settings
set casesensitive

# Include all syntax files
include ~/.nano/syntax/*.nanorc

# Colors (Termux compatible)
set titlecolor white,blue
set statuscolor white,green
set keycolor brightred
set functioncolor green
set numbercolor cyan
set selectedcolor white,magenta
set errorcolor white,red

# Brackets
set brackets "()[]{}<>"

# Key bindings that work in Termux
bind ^S writeout main
bind ^Q exit main
bind ^F whereis main
bind ^G gotoline main 
bind ^K cut main
bind ^U paste main 
bind ^O writeout main
bind ^R insert main
CONFIG

echo ""
echo "Nano setup complete!"
echo ""
echo "Nano version: $(nano --version | head -1)"
echo ""
echo "Test it: nano bot.js"
