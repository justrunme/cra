#!/bin/bash
set -e

INSTALL_PATH="/usr/local/bin"
RAW_URL="https://raw.githubusercontent.com/justrunme/cra/main"
NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")

echo "📦 Installing create-repo..."
echo "⏱ Started at: $NOW"

# ✅ Проверка зависимостей
for cmd in curl jq; do
  if ! command -v $cmd &>/dev/null; then
    echo "❌ Required dependency '$cmd' is missing. Please install it first."
    exit 1
  fi
done

# ✅ Проверка прав
if [ "$EUID" -ne 0 ]; then
  echo "❗ This script requires root privileges. Please run with sudo."
  exit 1
fi

# 📥 Загрузка файлов
echo "📥 Downloading create-repo..."
curl -fsSL "$RAW_URL/create-repo" -o "$INSTALL_PATH/create-repo"
echo "📥 Downloading update-all..."
curl -fsSL "$RAW_URL/update-all" -o "$INSTALL_PATH/update-all"

# ✅ Проверка успешной загрузки
if [ ! -s "$INSTALL_PATH/create-repo" ] || [ ! -s "$INSTALL_PATH/update-all" ]; then
  echo "❌ Failed to download one or both scripts."
  exit 1
fi

chmod +x "$INSTALL_PATH/create-repo" "$INSTALL_PATH/update-all"

# ⚙️ Конфигурационные файлы
CONFIG_FILE="$HOME/.create-repo.conf"
REPO_LIST="$HOME/.repo-autosync.list"

[ ! -f "$CONFIG_FILE" ] && cat <<EOF > "$CONFIG_FILE"
default_cron_interval=1
default_visibility=public
EOF

[ ! -f "$REPO_LIST" ] && touch "$REPO_LIST"

# 🔁 Автосинхронизация (cron / launchd)
INTERVAL=$(grep default_cron_interval "$CONFIG_FILE" | cut -d= -f2)
INTERVAL=${INTERVAL:-1}

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS — LaunchAgent
  plist="$HOME/Library/LaunchAgents/com.create-repo.auto.plist"
  cat > "$plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
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
  echo "✅ launchd job loaded"
else
  # Linux / WSL — cron
  echo "🕒 Adding cron job (Linux/WSL)"
  (crontab -l 2>/dev/null; echo "*/$INTERVAL * * * * $INSTALL_PATH/update-all # auto-sync by create-repo") | sort -u | crontab -

  # ✅ Проверка установки cron
  if crontab -l | grep -q "$INSTALL_PATH/update-all"; then
    echo "✅ Cron job added"
  else
    echo "⚠️ Failed to add cron job"
  fi
fi

# 🔗 Alias
ln -sf "$INSTALL_PATH/create-repo" "$INSTALL_PATH/cra"

# 🏁 Завершение
echo ""
echo "✅ create-repo installed!"
echo "📂 create-repo: $INSTALL_PATH/create-repo"
echo "📂 update-all : $INSTALL_PATH/update-all"
echo "🧠 Try:        create-repo --interactive"
echo "🔁 Auto-sync:  every $INTERVAL min"
echo "📝 Config:     $CONFIG_FILE"
echo "📁 Repos:      $REPO_LIST"
VERSION=$(curl -s https://api.github.com/repos/justrunme/cra/releases/latest | jq -r .tag_name)
echo "🔖 Version:    $VERSION"
