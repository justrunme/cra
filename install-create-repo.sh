#!/bin/bash
set -e

INSTALL_PATH="/usr/local/bin"
RAW_URL="https://raw.githubusercontent.com/justrunme/cra/main"
NOW=$(date +"%Y-%m-%dT%H:%M:%S%z")

echo "📦 Installing create-repo..."
echo "⏱ Started at: $NOW"

# ✅ Check root
if [ "$EUID" -ne 0 ]; then
  echo "❗ Please run with sudo."
  exit 1
fi

# ✅ Check dependencies
for dep in curl jq git; do
  if ! command -v $dep &>/dev/null; then
    echo "❗ Required dependency '$dep' is missing. Installing..."
    sudo apt-get update && sudo apt-get install -y $dep
  fi
done

# ✅ Download scripts
echo "📥 Downloading create-repo..."
curl -fsSL "$RAW_URL/create-repo" -o "$INSTALL_PATH/create-repo"
echo "📥 Downloading update-all..."
curl -fsSL "$RAW_URL/update-all" -o "$INSTALL_PATH/update-all"

# ✅ Validate downloads
if [ ! -s "$INSTALL_PATH/create-repo" ] || [ ! -s "$INSTALL_PATH/update-all" ]; then
  echo "❌ Download failed — check your internet connection or GitHub availability."
  exit 1
fi

chmod +x "$INSTALL_PATH/create-repo" "$INSTALL_PATH/update-all"

# 🔗 Create alias
ln -sf "$INSTALL_PATH/create-repo" "$INSTALL_PATH/cra"

# 🧠 Create config files if missing
CONFIG_FILE="$HOME/.create-repo.conf"
REPO_LIST="$HOME/.repo-autosync.list"

[ ! -f "$CONFIG_FILE" ] && {
  echo "⚙️ Creating default config at: $CONFIG_FILE"
  cat <<EOF > "$CONFIG_FILE"
default_visibility=public
default_cron_interval=1
default_team=
default_branch=main
EOF
}

[ ! -f "$REPO_LIST" ] && {
  echo "📝 Creating empty tracking list: $REPO_LIST"
  touch "$REPO_LIST"
}

# ⏱ Auto-sync setup
INTERVAL=$(grep default_cron_interval "$CONFIG_FILE" | cut -d= -f2)
INTERVAL=${INTERVAL:-1}

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🖥 Setting up launchctl (macOS)"
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
  echo "✅ macOS background sync setup complete"
else
  echo "🕒 Adding cron job (Linux/WSL)"
  (crontab -l 2>/dev/null; echo "*/$INTERVAL * * * * $INSTALL_PATH/update-all # auto-sync by create-repo") \
    | sort -u | crontab -

  if crontab -l | grep -q "$INSTALL_PATH/update-all"; then
    echo "✅ Cron job added"
  else
    echo "⚠️ Failed to add cron job"
  fi
fi

# 📦 Done
echo ""
echo "✅ create-repo installed!"
echo "📂 create-repo: $INSTALL_PATH/create-repo"
echo "📂 update-all : $INSTALL_PATH/update-all"
echo "🧠 Try:        create-repo --interactive"
echo "🔁 Auto-sync:  every $INTERVAL min"
echo "📝 Config:     $CONFIG_FILE"
echo "📁 Repos:      $REPO_LIST"
echo "🔖 Version:    $(grep '^version=' "$INSTALL_PATH/create-repo" | cut -d= -f2 || echo unknown)"
