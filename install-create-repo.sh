#!/bin/bash
set -e

INSTALL_PATH="/usr/local/bin"
RAW_URL="https://raw.githubusercontent.com/justrunme/cra/main"
NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")

echo "📦 Installing create-repo..."
echo "⏱ Started at: $NOW"

# Check root permissions
if [ "$EUID" -ne 0 ]; then
  echo "❗ This script requires root privileges. Please run with sudo."
  exit 1
fi

# Download main scripts
echo "📥 Downloading create-repo..."
curl -fsSL "$RAW_URL/create-repo" -o "$INSTALL_PATH/create-repo"
echo "📥 Downloading update-all..."
curl -fsSL "$RAW_URL/update-all" -o "$INSTALL_PATH/update-all"

# Check downloads
if [ ! -s "$INSTALL_PATH/create-repo" ] || [ ! -s "$INSTALL_PATH/update-all" ]; then
  echo "❌ Failed to download one or both scripts."
  exit 1
fi

chmod +x "$INSTALL_PATH/create-repo" "$INSTALL_PATH/update-all"

# Create config files if needed
CONFIG_FILE="$HOME/.create-repo.conf"
REPO_LIST="$HOME/.repo-autosync.list"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "⚙️ Creating config: $CONFIG_FILE"
  cat <<EOF > "$CONFIG_FILE"
default_cron_interval=1
default_visibility=public
EOF
fi

if [ ! -f "$REPO_LIST" ]; then
  echo "📝 Creating tracked repo list: $REPO_LIST"
  touch "$REPO_LIST"
fi

# Add cron or launchd
INTERVAL=$(grep default_cron_interval "$CONFIG_FILE" | cut -d= -f2)
INTERVAL=${INTERVAL:-1}

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  echo "🖥 Setting up launchctl on macOS"
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
  echo "✅ launchd job loaded"

else
  # Linux / WSL
  echo "🕒 Adding cron job for Linux/WSL"
  (crontab -l 2>/dev/null; echo "*/$INTERVAL * * * * $INSTALL_PATH/update-all # auto-sync by create-repo") | sort -u | crontab -

  if crontab -l | grep -q "$INSTALL_PATH/update-all"; then
    echo "✅ Cron job successfully added"
  else
    echo "⚠️ Failed to add cron job"
  fi
fi

# Alias
ln -sf "$INSTALL_PATH/create-repo" "$INSTALL_PATH/cra"

# Done
echo ""
echo "✅ create-repo installed successfully!"
echo "⏱ Finished at: $(date +"%Y-%m-%dT%H:%M:%S%z")"
echo "🧠 Tip: run 'cra --help' or 'create-repo --interactive' to start"
echo "⚙️ Config: $CONFIG_FILE"
echo "📝 Tracked repos: $REPO_LIST"
