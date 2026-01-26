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
wget --retry-connrefused --tries=30 https://aur.archlinux.org/cgit/aur.git/plain/gradia_ocr.patch?h=gradia -O ./gradia_ocr.patch
sed -i 's|Docr_original_tessdata_dir=/usr/share/tessdata|Docr_original_tessdata_dir=$XDG_DATA_HOME/tessdata|g' ./PKGBUILD
sed -i 's|self.user_tessdata_dir = os.path.expanduser(f"~/.local/var/app/{app_id}/data/tessdata")|self.user_tessdata_dir = os.path.join(os.environ.get("XDG_DATA_HOME", os.path.expanduser("~/.local/share")), "tessdata")|' ./gradia_ocr.patch
sed -i 's|770b874fed71ec84a6a190b6e931be9189f512b4433eaef8996dca32644472d7|50111f370140fa69773ac66520fdb3d33bc1bc093704bffc1447a0634e74c9df|g' ./PKGBUILD
make-aur-package
