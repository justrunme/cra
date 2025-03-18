#!/bin/bash
set -e

INSTALL_PATH="/usr/local/bin"
RAW_URL="https://raw.githubusercontent.com/justrunme/cra/main"
NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")

echo "📦 Installing create-repo..."
echo "⏱ Started at: $NOW"

# Check root
if [ "$EUID" -ne 0 ]; then
  echo "❗ This script requires root privileges. Please run with sudo."
  exit 1
fi

# Download
curl -fsSL "$RAW_URL/create-repo" -o "$INSTALL_PATH/create-repo"
curl -fsSL "$RAW_URL/update-all" -o "$INSTALL_PATH/update-all"
chmod +x "$INSTALL_PATH/create-repo" "$INSTALL_PATH/update-all"

# Create config files
CONFIG_FILE="$HOME/.create-repo.conf"
REPO_LIST="$HOME/.repo-autosync.list"

[ ! -f "$CONFIG_FILE" ] && cat <<EOF > "$CONFIG_FILE"
default_cron_interval=1
default_visibility=public
EOF

[ ! -f "$REPO_LIST" ] && touch "$REPO_LIST"

# Auto-sync (cron or launchd)
INTERVAL=$(grep default_cron_interval "$CONFIG_FILE" | cut -d= -f2)
INTERVAL=${INTERVAL:-1}

if [[ "$OSTYPE" == "darwin"* ]]; then
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
  (crontab -l 2>/dev/null; echo "*/$INTERVAL * * * * $INSTALL_PATH/update-all # auto-sync by create-repo") | sort -u | crontab -
  echo "✅ Cron job added"
fi

ln -sf "$INSTALL_PATH/create-repo" "$INSTALL_PATH/cra"

# Done
echo ""
echo "✅ create-repo installed!"
echo "📂 create-repo: $INSTALL_PATH/create-repo"
echo "📂 update-all : $INSTALL_PATH/update-all"
echo "🧠 Try:        create-repo --interactive"
echo "🔁 Auto-sync:  every $INTERVAL min"
echo "📝 Config:     $CONFIG_FILE"
echo "📁 Repos:      $REPO_LIST"
echo "🔖 Version:    $(create-repo --version || echo dev)"
