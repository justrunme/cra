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

# Control-файл
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
cp create-repo "$BUILD_DIR/usr/local/bin/create-repo"
cp update-all.sh "$BUILD_DIR/usr/local/bin/update-all"

# Делаем исполняемыми
chmod +x "$BUILD_DIR/usr/local/bin/"*

# Сборка .deb
dpkg-deb --build "$BUILD_DIR" "$OUT_DIR/${PACKAGE_NAME}_${VERSION}.deb"

echo "✅ Готово: $OUT_DIR/${PACKAGE_NAME}_${VERSION}.deb"

# Добавляем postinst
cat <<'EOF' > "$BUILD_DIR/DEBIAN/postinst"
#!/bin/bash
SCRIPT_PATH="/usr/local/bin/update-all"
REPO_LIST="$HOME/.repo-autosync.list"

if [ ! -f "$REPO_LIST" ]; then
  echo "📄 Создаю $REPO_LIST"
  touch "$REPO_LIST"
fi

if ! crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH"; then
  (crontab -l 2>/dev/null; echo "*/5 * * * * $SCRIPT_PATH") | crontab -
  echo "🕒 Добавлена задача в cron: $SCRIPT_PATH"
else
  echo "ℹ️ Задача уже существует в crontab."
fi
EOF
chmod 755 "$BUILD_DIR/DEBIAN/postinst"

# Добавляем prerm
cat <<'EOF' > "$BUILD_DIR/DEBIAN/prerm"
#!/bin/bash
SCRIPT_PATH="/usr/local/bin/update-all"
TMP_CRON=$(mktemp)
crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" > "$TMP_CRON"
crontab "$TMP_CRON"
rm "$TMP_CRON"
echo "🧹 Задача cron удалена: $SCRIPT_PATH"
EOF
chmod 755 "$BUILD_DIR/DEBIAN/prerm"
