#!/usr/bin/env python3

import os

config = [
    "kdeglobals",
    "kglobalshortcutsrc",
    "plasma-org.kde.plasma.desktop-appletsrc",
    "plasmashellrc",
    "gtkrc",
    "gtkrc-2.0",
    "kconf_updaterc",
    "spectaclerc",
    "bluedevilglobalrc",
]

local_share = [
    "krunnerstaterc",
    "user-places.xbel",
]

git_assume_unchanged = "git update-index --assume-unchanged"
git_assume_unchanged_disable = "git update-index --no-assume-unchanged"

flake_location = os.environ.get("FLAKE")

files = []
for filename in config:
    files.append(f"{flake_location}/dotfiles/.config/{filename}")
for filename in local_share:
    files.append(f"{flake_location}/dotfiles/.local/share/{filename}")

for file in files:
    os.system(f"{git_assume_unchanged} {file}")