#!/bin/sh

set -eu

ARCH=$(uname -m)

pacman -Syu --noconfirm webp-pixbuf-loader python-pandas

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"

echo '
*** Begin Patch
*** Update File: gradia/backend/ocr.py
@@
     def __init__(self, window=None):
         self.tesseract_cmd = ocr_tesseract_cmd
         self.original_tessdata_dir = ocr_original_tessdata
-        self.user_tessdata_dir = os.path.expanduser(f"~/.var/app/{app_id}/data/tessdata")
+        # Use XDG_DATA_HOME for per-user tessdata (default to ~/.local/share)
+        xdg_data_home = os.getenv('XDG_DATA_HOME', os.path.expanduser('~/.local/share'))
+        self.user_tessdata_dir = os.path.join(xdg_data_home, app_id, 'tessdata')
         self.window = window
 
         pytesseract.pytesseract.tesseract_cmd = self.tesseract_cmd
*** End Patch
' >> ./gradia_ocr.patch

wget --retry-connrefused --tries=30 https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=gradia -O ./PKGBUILD
make-aur-package
