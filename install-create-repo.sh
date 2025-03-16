#!/bin/bash
set -e

# 🎨 Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# ⚙️ Flags
SILENT=false
DEBUG=false
for arg in "$@"; do
  [[ "$arg" == "--silent" ]] && SILENT=true
  [[ "$arg" == "--debug" ]] && DEBUG=true
done

log() {
  $SILENT || echo -e "$1"
}

debug() {
  $DEBUG && echo -e "${YELLOW}[DEBUG] $1${RESET}"
}

error_exit() {
  echo -e "${RED}❌ $1${RESET}"
  exit 1
}

# 📦 Инфо
INSTALL_PATH="/usr/local/bin"
RAW_URL="https://raw.githubusercontent.com/justrunme/cra/main"
CONFIG_FILE="$HOME/.create-repo.conf"
REPO_LIST="$HOME/.repo-autosync.list"

log "${YELLOW}📦 Installing create-repo...${RESET}"

# ✅ Проверки
command -v curl >/dev/null || error_exit "curl не найден. Установите его и попробуйте снова."
command -v bash >/dev/null || error_exit "bash не найден."
command -v chmod >/dev/null || error_exit "chmod не найден."

# ⬇️ Скачиваем файлы
for file in create-repo update-all; do
  log "📥 Downloading $file..."
  curl -fsSL "$RAW_URL/$file" -o "$INSTALL_PATH/$file" || error_exit "Ошибка загрузки $file"
  chmod +x "$INSTALL_PATH/$file"
done

# 📝 Конфиги
if [ ! -f "$CONFIG_FILE" ]; then
  log "🛠️ Creating default config..."
  cat <<EOF > "$CONFIG_FILE"
default_cron_interval=1
default_visibility=public
EOF
fi

[ ! -f "$REPO_LIST" ] && { log "📄 Creating repo list file..."; touch "$REPO_LIST"; }

# 🕒 Синхронизация
INTERVAL=$(grep default_cron_interval "$CONFIG_FILE" | cut -d= -f2)
INTERVAL=${INTERVAL:-1}

if [[ "$OSTYPE" == "darwin"* ]]; then
  log "🖥 Setting up launchctl (macOS)..."
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
  log "🕒 Adding cron job (Linux/WSL)..."
  (crontab -l 2>/dev/null; echo "*/$INTERVAL * * * * $INSTALL_PATH/update-all # auto-sync by create-repo") | sort -u | crontab -
fi

# 🔗 Alias
ln -sf "$INSTALL_PATH/create-repo" "$INSTALL_PATH/cra"

# ✅ Готово
log ""
log "${GREEN}✅ create-repo installed!${RESET}"
log "🛠 Use: create-repo [name] [flags]"
log "⚙️ Config: $CONFIG_FILE"
log "📝 Tracked repos: $REPO_LIST"
log "🚀 Try: cra --help"
