#!/bin/sh

set -eu

ARCH=$(uname -m)

pacman -Syu --noconfirm webp-pixbuf-loader python-pandas

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"

wget --retry-connrefused --tries=30 https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=gradia -O ./PKGBUILD
# For OCR patch pass
sed -i 's/770b874fed71ec84a6a190b6e931be9189f512b4433eaef8996dca32644472d7/9663c58a7cf811470962133bc534446cdca8954432db543a5fa05aa44e381116/g' ./PKGBUILD
make-aur-package
