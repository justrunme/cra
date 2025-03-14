#!/bin/bash

set -e

PACKAGE_NAME="repo-tools"
BASE_VERSION="1.0"
COMMIT_COUNT=$(git rev-list --count HEAD)
VERSION="$BASE_VERSION.$COMMIT_COUNT"
ARCH="amd64"
BUILD_DIR="build"
OUT_DIR="out"
BIN_DIR="$BUILD_DIR/usr/local/bin"
DEBIAN_DIR="$BUILD_DIR/DEBIAN"

echo "🔢 Версия пакета: $VERSION"

# Очистка
rm -rf "$BUILD_DIR" "$OUT_DIR"
mkdir -p "$BIN_DIR" "$DEBIAN_DIR" "$OUT_DIR"

echo "📦 Подготовка .deb-пакета..."

# === CONTROL ===
cat <<EOF > "$DEBIAN_DIR/control"
Package: $PACKAGE_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: DevOps Bash Toolkit <devops@example.com>
Description: CLI-инструменты: create-repo и update-all
EOF

# === postinst (cron install) ===
cat <<'EOF' > "$DEBIAN_DIR/postinst"
#!/bin/bash
SCRIPT_PATH="/usr/local/bin/update-all"
REPO_LIST="$HOME/.repo-autosync.list"

if [ ! -f "$REPO_LIST" ]; then
  echo "📄 Создаю $REPO_LIST"
  touch "$REPO_LIST"
fi

if ! crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH"; then
  (crontab -l 2>/dev/null; echo "*/1 * * * * $SCRIPT_PATH") | sort -u | crontab -
  echo "🕒 Задача добавлена в cron: $SCRIPT_PATH"
else
  echo "ℹ️ Задача уже есть в crontab."
fi
EOF
chmod 755 "$DEBIAN_DIR/postinst"

# === prerm (удаление из cron) ===
cat <<'EOF' > "$DEBIAN_DIR/prerm"
#!/bin/bash
SCRIPT_PATH="/usr/local/bin/update-all"
TMP_CRON=$(mktemp)
crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" > "$TMP_CRON"
crontab "$TMP_CRON"
rm "$TMP_CRON"
echo "🧹 Задача cron удалена: $SCRIPT_PATH"
EOF
chmod 755 "$DEBIAN_DIR/prerm"

# === Копирование исполняемых файлов ===
cp create-repo "$BIN_DIR/create-repo"
cp update-all.sh "$BIN_DIR/update-all"
chmod +x "$BIN_DIR/"*

# === Сборка ===
DEB_PATH="$OUT_DIR/${PACKAGE_NAME}_${VERSION}.deb"
dpkg-deb --build "$BUILD_DIR" "$DEB_PATH"

echo "✅ Пакет собран: $DEB_PATH"
