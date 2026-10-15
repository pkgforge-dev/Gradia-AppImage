#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	appstream          \
	bash               \
	blueprint-compiler \
	curl               \
	dconf              \
	gdk-pixbuf2        \
	graphene           \
	gtk4               \
	gtksourceview5     \
	hicolor-icon-theme \
	libadwaita         \
	libportal          \
	libsoup3           \
	meson              \
	pango              \
	python             \
	python-cairo       \
	python-gobject     \
	python-pillow      \
	python-pytesseract \
	tesseract          \
	webp-pixbuf-loader

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building Gradia from source..."
echo "---------------------------------------------------------------"
git clone https://github.com/AlexanderVanhee/Gradia ./Gradia && (
	cd ./Gradia

	git fetch --tags origin
	TAG=$(git tag --sort=-v:refname | grep -vi 'rc\|alpha\|beta\|nightly' | head -1)
	git checkout "$TAG"
	echo "${TAG#v}" > ~/version

	# Keep the gradient library relocatable, resolve the OCR paths inside
	# the AppImage and fix the rotation buttons direction
	git apply ../patches/*.patch

	meson setup build --prefix=/usr --buildtype=release
	meson compile -C build
	meson install -C build
)

# Ship a default OCR language and script detection in the lighter
# tessdata_fast format so OCR works without downloading a model first
# (the Arch package only ships osd and no language data)
echo "Downloading tesseract script models..."
echo "---------------------------------------------------------------"
tessdata_dir=/usr/share/tessdata
tessdata_source=https://github.com/tesseract-ocr/tessdata_fast/raw/main
rm -f "$tessdata_dir"/*.traineddata
for lang in eng osd; do
	echo "Downloading $lang.traineddata"
	curl -fL --retry 30 --retry-connrefused --retry-delay 1 \
		"$tessdata_source/$lang.traineddata" -o "$tessdata_dir/$lang.traineddata"
done
