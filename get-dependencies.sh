#!/bin/sh

set -eu

ARCH=$(uname -m)

pacman -Syu --noconfirm webp-pixbuf-loader

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
make-aur-package gradia
