#!/bin/sh

# Dock installer.

mkdir -p ~/.dock/programs
curl https://raw.githubusercontent.com/Desyncfy/dock/refs/heads/main/dock.sh > ~/.dock/dock
chmod +x ~/.dock/dock
touch ~/.dock/packages.txt
echo """Welcome to Dock!

Next steps:

1. Add ~/.dock and ~/.dock/programs to your Path
Bash: export PATH="\$PATH:~/.dock"; export PATH="\$PATH:~/.dock/programs" (add to ~/.bashrc)
Fish: set fish_user_paths ~/.dock ~/.dock/programs \$fish_user_paths

2. Install a package
dock install <package>"""
