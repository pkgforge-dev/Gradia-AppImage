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
sed 's/770b874fed71ec84a6a190b6e931be9189f512b4433eaef8996dca32644472d7/9e4bde8a8343f20f69b87e107dae04c1fc6cb09b430872f354fda7fea376b06e/g' ./PKGBUILD
make-aur-package
