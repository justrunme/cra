```markdown
# 🛠 create-repo

A powerful CLI tool to instantly initialize, publish, and auto-sync Git repositories (GitHub, GitLab, Bitbucket) with background syncing via **cron (Linux)** or **launchd (macOS)**.  
Supports auto-updates, `.deb` / `.pkg` packaging, templates, CI/CD and much more.

---

## 🚀 Features

- ✅ Interactive first-run setup (`~/.create-repo.conf`)
- ✅ Auto-detection of platform (GitHub / GitLab / Bitbucket)
- ✅ Create and push to remote repo automatically
- ✅ Initializes Git repo with `main`/`master` branch
- ✅ Automatically adds `.gitignore` and `README.md`
- ✅ Adds project to `~/.repo-autosync.list`
- ✅ `.env` file support
- ✅ Background auto-sync via cron/launchd
- ✅ Colorful logs + error logging
- ✅ Team collaboration: `--share`, `--team`, `--contributors`
- ✅ Self-update: `--update`
- ✅ GitHub CLI + GUI Git client integration
- ✅ Notifications on Linux/macOS
- ✅ CI/CD builds `.deb` and `.pkg` releases automatically

---

## 📦 Installation

### 🔹 Universal installation (Linux & macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/justrunme/cra/main/install.sh | bash
```

This installs `create-repo` and `update-all`, sets up syncing via cron/launchd, and creates useful aliases like `cra`.

---

## 🔧 Alternative manual install

### 📥 For Linux (.deb)

```bash
sudo apt install -y jq
curl -s https://api.github.com/repos/justrunme/cra/releases/latest \
| jq -r '.assets[] | select(.name | endswith(".deb")) | .browser_download_url' \
| xargs wget -O create-repo.deb
sudo dpkg -i create-repo.deb
```

### 🍏 For macOS (.pkg)

```bash
curl -s https://api.github.com/repos/justrunme/cra/releases/latest \
| jq -r '.assets[] | select(.name | endswith(".pkg")) | .browser_download_url' \
| xargs wget -O create-repo.pkg
sudo installer -pkg create-repo.pkg -target /
```

---

## 🧠 Usage

```bash
create-repo [name] [options]
```

If no name is provided, the current folder name will be used.

---

## 🔄 First Run Setup

You'll be prompted for:

```
📦 Repo name [my-folder]:
🔐 Type (public/private) [public]:
👥 GitHub team (optional) [none]:
⏱ Sync interval in minutes [1]:
```

Settings are stored in `~/.create-repo.conf` for future use.

---

## ⚙️ Options

| Flag              | Description |
|-------------------|-------------|
| `--interactive`   | Force setup questions again |
| `--status`        | Show background sync status |
| `--log [N]`       | View last N log lines |
| `--list`          | Show all tracked repos |
| `--remove`        | Remove current repo from tracking |
| `--clean`         | Remove non-existent paths from tracking |
| `--share`         | Show repo + team share link |
| `--team <name>`   | Set GitHub team |
| `--contributors`  | List contributors |
| `--update`        | Update tool to latest release |
| `--pull-only`     | Only pull changes without push |
| `--dry-run`       | Run without pushing |
| `--version`       | Show current version |
| `--help`          | Display help |

---

## 🔁 Background Auto-Sync

### Linux (via `cron`):

```bash
*/N * * * * /usr/local/bin/update-all  # auto-sync by create-repo
```

### macOS (via `launchd`):

```bash
~/Library/LaunchAgents/com.create-repo.auto.plist
```

The `update-all` tool:
- detects `.env` and main branch
- commits + pushes changes
- logs to `~/.create-repo.log`, errors to `~/.create-repo-errors.log`

---

## 🧩 Templates

Add custom `.gitignore` or `README.md` templates:

```bash
~/.create-repo/templates/python.gitignore
~/.create-repo/templates/node.gitignore
```

They’re applied if the project contains relevant files like `main.py`, `package.json`, etc.

---

## 📜 Config File (`~/.create-repo.conf`)

```ini
# ~/.create-repo.conf — Global config

# Repo visibility
default_visibility=private

# Sync interval (in minutes)
default_cron_interval=5

# GitHub team (optional)
default_team=devops-team
```

---

## 🧪 CI/CD & GitHub Actions

✅ Automated CI/CD includes:

- `.deb` and `.pkg` builds
- Smoke tests
- Validation & changelog
- Auto-release with version tag
- Publishing to GitHub Releases

✅ Each release includes:

- `create-repo_x.y.z.deb`
- `create-repo_x.y.z.pkg`
- `install-create-repo.sh`
- Full source

---

## 👥 Collaboration Features

| Feature           | Command |
|------------------|---------|
| Share repo link  | `create-repo --share` |
| Assign team      | `create-repo --team devops` |
| View contributors| `create-repo --contributors` |

---

## 🧪 Examples

```bash
create-repo my-app              # Create repo
create-repo --log 50            # Show last 50 logs
create-repo --interactive       # Rerun setup
create-repo --remove            # Untrack this repo
create-repo --update            # Update CLI
create-repo --share --team devs # Team share link
```

---

## 🧰 Requirements

| Tool / CLI      | Purpose |
|------------------|---------|
| `git`            | Git operations |
| `gh`             | GitHub integration |
| `curl`           | API requests |
| `jq`             | Parsing GitHub API responses |
| `notify-send` / `osascript` | GUI notifications |

---

## 💡 Highlights

- 🔄 Smart auto-sync with Git
- 🔧 Full customization
- 📦 GitHub-powered CI/CD for releases
- 🧠 `.env`, `.gitignore`, and templates support
- 🎨 Clean UX and alias `cra`

---

## 👨‍💻 Author

**justrunme**  
🔗 GitHub: [github.com/justrunme](https://github.com/justrunme)

---

🙋‍♂️ Got an idea? Want to contribute?  
Just run:

```bash
create-repo --interactive
```

---

📦 _Install. Run. Automate._  
🚀 **Welcome to DevOps Zen.**
```
