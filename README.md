---

```markdown
# 🛠 create-repo

A powerful CLI tool to instantly **initialize, publish, and auto-sync** Git repositories (GitHub, GitLab, Bitbucket) — with background syncing via **cron (Linux)** or **launchd (macOS)**.  
Supports **auto-updates**, `.deb` / `.pkg` packaging, **CI/CD**, custom templates, and more.

---

## 🚀 Features

- ✅ Interactive first-run setup (`~/.create-repo.conf`)
- ✅ Auto-detection of platform (GitHub / GitLab / Bitbucket)
- ✅ Instantly creates and pushes to remote repo
- ✅ Initializes Git repo with `main` / `master`
- ✅ Auto-adds `.gitignore`, `README.md`
- ✅ Adds project to `~/.repo-autosync.list`
- ✅ `.env` file support
- ✅ Background auto-sync (cron / launchd)
- ✅ Colorful logs + error logging
- ✅ Team collaboration: `--share`, `--team`, `--contributors`
- ✅ One-command self-update: `--update`
- ✅ GitHub CLI + GUI Git client integration
- ✅ Desktop notifications (Linux / macOS / WSL)
- ✅ GitHub Actions CI/CD builds `.deb`, `.pkg`, and `install.sh`

---

## 📦 Installation

### 🧩 Recommended (Linux & macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/justrunme/cra/main/install-create-repo.sh | bash
```

This installs `create-repo`, sets up auto-syncing, and adds the `cra` alias.

---

<details>
<summary>🛠 Manual Installation</summary>

### 📥 Linux (.deb)

```bash
sudo apt install -y jq
curl -s https://api.github.com/repos/justrunme/cra/releases/latest \
| jq -r '.assets[] | select(.name | endswith(".deb")) | .browser_download_url' \
| xargs wget -O create-repo.deb
sudo dpkg -i create-repo.deb
```

### 🍏 macOS (.pkg)

```bash
curl -s https://api.github.com/repos/justrunme/cra/releases/latest \
| jq -r '.assets[] | select(.name | endswith(".pkg")) | .browser_download_url' \
| xargs wget -O create-repo.pkg
sudo installer -pkg create-repo.pkg -target /
```

</details>

---

## 🧠 Usage

```bash
create-repo [name] [flags]
```

If no name is provided, the current folder name will be used.  
On first run, you'll be asked:

```
📦 Repo name [my-folder]:
🔐 Type (public/private) [public]:
👥 GitHub team (optional) [none]:
⏱ Sync interval in minutes [1]:
```

---

## ⚙️ Available Flags

| Flag              | Description |
|-------------------|-------------|
| `--interactive`   | Re-run setup |
| `--status`        | Check auto-sync status |
| `--log [N]`       | Show last N logs |
| `--list`          | Show tracked repos |
| `--remove`        | Untrack this repo |
| `--clean`         | Remove non-existent paths |
| `--share`         | Share repo + team link |
| `--team <name>`   | Set default GitHub team |
| `--contributors`  | List contributors |
| `--update`        | Update to latest release |
| `--pull-only`     | Pull only (no push) |
| `--dry-run`       | Test mode (no changes) |
| `--version`       | Show installed version |
| `--help`          | Show help |

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
- Commits + pushes changes
- Detects `.env`, `main/master`
- Logs to `~/.create-repo.log`, errors in `~/.create-repo-errors.log`

---

## 🧩 Templates

Add custom `.gitignore` / `README.md` templates in:

```bash
~/.create-repo/templates/python.gitignore
~/.create-repo/templates/node.gitignore
```

Auto-applied if matching files like `main.py`, `package.json` are present.

---

## 🧪 CI/CD (GitHub Actions)

✅ Fully automated:
- `.deb` & `.pkg` builds
- Smoke tests
- Changelog generation
- GitHub Releases with versioning

✅ Each Release Includes:
- `create-repo_X.Y.Z.deb`
- `create-repo_X.Y.Z.pkg`
- `install-create-repo.sh`
- Full source code

---

## 👥 Collaboration

| Feature           | Command |
|------------------|---------|
| Share repo link  | `create-repo --share` |
| Set GitHub team  | `create-repo --team devops` |
| List contributors| `create-repo --contributors` |

---

## 📜 Config (`~/.create-repo.conf`)

```ini
default_visibility=private
default_cron_interval=5
default_team=devops-team
```

---

## 🧪 Examples

```bash
create-repo my-app
create-repo --log 30
create-repo --remove
create-repo --update
create-repo --interactive
create-repo --share --team devs
```

---

## ⚙️ Requirements

| Tool / CLI       | Used for...         |
|------------------|---------------------|
| `git`            | Git ops             |
| `gh`             | GitHub CLI          |
| `curl`, `jq`     | API handling        |
| `notify-send` / `osascript` | Notifications |

---

## 👨‍💻 Author

**justrunme**  
🔗 GitHub: [github.com/justrunme](https://github.com/justrunme)

---

🙋 Have ideas or feedback?  
Run:

```bash
create-repo --interactive
```

---

📦 _Install. Run. Automate._  
🚀 **Welcome to DevOps Zen.**
```
