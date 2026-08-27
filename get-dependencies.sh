#!/bin/sh

set -eu

ARCH=$(uname -m)

pacman -Syu --noconfirm webp-pixbuf-loader python-pandas gradia

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano
