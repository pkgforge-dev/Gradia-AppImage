#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q gradia | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/be.alexandervanhee.gradia.svg
export DESKTOP=/usr/share/applications/be.alexandervanhee.gradia.desktop
export DEPLOY_SYS_PYTHON=1
export DEPLOY_GTK=1
export GTK_DIR=gtk-4.0
export ANYLINUX_LIB=1
export DEPLOY_LOCALE=1
export STARTUPWMCLASS=be.alexandervanhee.gradia # Default to Wayland's wmclass. For X11, GTK_CLASS_FIX will force the wmclass to be the Wayland one.
export GTK_CLASS_FIX=1

# Deploy dependencies
quick-sharun /usr/bin/gradia \
             /usr/lib/libgirepository* \
             /usr/lib/gio/modules/libgiognutls.so* \
             /usr/lib/libsoup*

# Patch Gradia to use AppImage's directory
sed -i '/^pkgdatadir/c\pkgdatadir = os.getenv("SHARUN_DIR", "/usr") + "/share/gradia"' ./AppDir/bin/gradia
sed -i '/^localedir/c\localedir = os.getenv("SHARUN_DIR", "/usr") + "/share/locale"' ./AppDir/bin/gradia

# Turn AppDir into AppImage
quick-sharun --make-appimage
