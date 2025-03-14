#!/bin/bash

set -e

PACKAGE_NAME="repo-tools"
VERSION="1.0.1"
ARCH="amd64"
BUILD_DIR="build"
OUT_DIR="out"

# Очистка
rm -rf "$BUILD_DIR" "$OUT_DIR"
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/usr/local/bin"
mkdir -p "$OUT_DIR"

# Заполняем control
cat <<EOF > "$BUILD_DIR/DEBIAN/control"
Package: $PACKAGE_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: DevOps Bash Toolkit <devops@example.com>
Description: CLI-инструменты для автоматизации: create-repo и update-all.
EOF

# Копируем скрипты
cp create-repo.sh "$BUILD_DIR/usr/local/bin/create-repo"
cp update-all.sh "$BUILD_DIR/usr/local/bin/update-all"
chmod +x "$BUILD_DIR/usr/local/bin/"*

# Сборка .deb
dpkg-deb --build "$BUILD_DIR" "$OUT_DIR/${PACKAGE_NAME}_${VERSION}.deb"

echo "✅ Готово: $OUT_DIR/${PACKAGE_NAME}_${VERSION}.deb"
