#!/bin/bash
set -e

echo "📦 Установка create-repo..."

# ⬇️ Скачиваем скрипты
INSTALL_PATH="/usr/local/bin"
RAW_URL="https://raw.githubusercontent.com/justrunme/cra/main"

echo "📥 Загружаем create-repo..."
curl -fsSL "$RAW_URL/create-repo" -o "$INSTALL_PATH/create-repo"

echo "📥 Загружаем update-all..."
curl -fsSL "$RAW_URL/update-all" -o "$INSTALL_PATH/update-all"

chmod +x "$INSTALL_PATH/create-repo" "$INSTALL_PATH/update-all"

# 📁 Файлы конфигурации
CONFIG_FILE="$HOME/.create-repo.conf"
REPO_LIST="$HOME/.repo-autosync.list"

[ ! -f "$CONFIG_FILE" ] && {
  echo "🛠️ Создаём $CONFIG_FILE"
  cat <<EOF > "$CONFIG_FILE"
default_cron_interval=1
default_visibility=public
EOF
}

[ ! -f "$REPO_LIST" ] && {
  echo "📄 Создаём $REPO_LIST"
  touch "$REPO_LIST"
}

# 🕒 Настройка автосинхронизации
INTERVAL=$(grep default_cron_interval "$CONFIG_FILE" | cut -d= -f2)
INTERVAL=${INTERVAL:-1}

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  echo "🖥 Устанавливаем через launchctl (macOS)"
  plist="$HOME/Library/LaunchAgents/com.create-repo.auto.plist"
  cat > "$plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.create-repo.auto</string>
  <key>ProgramArguments</key>
  <array>
    <string>$INSTALL_PATH/update-all</string>
  </array>
  <key>StartInterval</key>
  <integer>$((INTERVAL * 60))</integer>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF
  launchctl unload "$plist" &>/dev/null || true
  launchctl load "$plist"

else
  # Linux / WSL
  echo "🕒 Добавляем задачу в cron (Linux/WSL)"
  (crontab -l 2>/dev/null; echo "*/$INTERVAL * * * * $INSTALL_PATH/update-all # auto-sync by create-repo") | sort -u | crontab -
fi

# 🔗 Alias
ln -sf "$INSTALL_PATH/create-repo" "$INSTALL_PATH/cra"

# ✅ Готово
echo ""
echo "✅ create-repo установлен!"
echo "🛠 Используй команду: create-repo [название] [флаги]"
echo "⚙️ Конфиг: $CONFIG_FILE"
echo "📝 Отслеживаемые проекты: $REPO_LIST"
echo "🚀 Попробуй: cra --help"
