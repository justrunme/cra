# 🛠 create-repo

![version](https://img.shields.io/github/v/release/justrunme/cra)
![license](https://img.shields.io/github/license/justrunme/cra)
![issues](https://img.shields.io/github/issues/justrunme/cra)
![build](https://img.shields.io/github/actions/workflow/status/justrunme/cra/build-deb.yml?label=build)

A powerful CLI tool to instantly **initialize, publish, and auto-sync** Git repositories across **GitHub, GitLab, Bitbucket**.  
Includes full automation, auto-updates, per-folder config, `.env` support, and **1-minute background syncing** via `cron` (Linux) or `launchd` (macOS).

---

## 🚀 Features

- ✅ First-run **interactive setup** (`~/.create-repo.conf`)
- ✅ **Multi-platform auto-detection** (GitHub / GitLab / Bitbucket)
- ✅ **Per-folder platform memory** (`~/.create-repo.platforms`)
- ✅ **Per-folder branch selection** and default `main` / `master` fallback
- ✅ Automatically **initializes** and **pushes** to remote
- ✅ Auto-creates `.gitignore`, `README.md` if missing
- ✅ **.env support** for secrets and tokens
- ✅ **Background syncing** every minute
- ✅ **Desktop notifications** on sync (Linux/macOS/WSL)
- ✅ **Version detection** from GitHub Releases
- ✅ `--update` flag updates **all components**
- ✅ **Cross-platform install**: `.deb`, `.pkg`, `install.sh`
- ✅ Supports **team collaboration** (`--team`, `--share`)
- ✅ Supports **global + local configs**
- ✅ ✅ Supports **auto-pull**, **auto-push**, **error logging**

---

## 📦 Installation

```bash
curl -fsSL https://raw.githubusercontent.com/justrunme/cra/main/install-create-repo.sh | sudo bash
```

Installs `create-repo` and `update-all`, sets up background sync (cron / launchd), adds `cra` alias.

---

## ⚙️ Usage

```bash
create-repo [repo-name] [flags]
```

If no name is provided, current folder name will be used.  
On first run or with `--interactive`, prompts:

```
📦 Repo name [my-folder]:
🔐 Visibility (public/private) [public]:
👥 GitHub team (optional):
⏱ Sync interval (min) [1]:
🌿 Branch [main]:
💾 Config scope [global/local]:
```

---

## 🧠 Flags & Options

| Flag                    | Description |
|-------------------------|-------------|
| `--interactive`         | Re-run setup |
| `--version`             | Show installed version |
| `--update`              | Update both create-repo + update-all |
| `--help`                | Show usage |
| `--platform=<name>`     | Force platform (github/gitlab/bitbucket) |
| `--platform-status`     | Show saved folder-to-platform bindings |
| `--sync-now`            | Manual sync of all repos |
| `--log [N]`             | Show last N sync logs |
| `--status`              | Show cron or launchd status |
| `--list`                | List all tracked repos |
| `--remove`              | Untrack current folder |
| `--clean`               | Remove non-existent paths from list |
| `--team <name>`         | Set GitHub team (applies globally) |
| `--contributors`        | List repo contributors |
| `--pull-only`           | Skip push, only pull |
| `--dry-run`             | No changes, just simulate |
| `--uninstall`           | Remove this repo from tracking |

---

## 🔗 Per-Folder Platform Mapping

If multiple platforms detected, you'll be asked once:

```bash
❓ Which platform to use? github / gitlab / bitbucket
```

Your choice is saved to:

```bash
~/.create-repo.platforms
```

You can override using:

```bash
create-repo --platform=gitlab
```

View bindings:

```bash
create-repo --platform-status
```

---

## 🌿 Per-Folder Branch Support

Each folder can use its own Git branch via:

```ini
# .create-repo.local.conf
default_branch=dev
```

Interactive setup allows choosing the default branch.

---

## 🔁 Auto-Sync (cron / launchd)

Every repo is tracked in:

```
~/.repo-autosync.list
```

Every N minutes (default: 1), the tool:

- auto-commits
- pulls & rebases
- pushes changes
- respects `.env` and `.create-repo.local.conf`

Disable auto-sync per repo:

```ini
# .create-repo.local.conf
disable_sync=true
```

---

## 🧩 Templates (Advanced)

Supports automatic templates for:

```bash
~/.create-repo/templates/python.gitignore
~/.create-repo/templates/node.gitignore
```

Applied based on files in the repo (`main.py`, `package.json`, etc.)

---

## 🧪 GitHub Actions CI/CD

Every release includes:

- `.deb`, `.pkg`, `install.sh`
- Automated builds
- Full versioning
- Smoke tests
- Auto-release to GitHub

---

## 👨‍💻 Author

**justrunme**  
📦 GitHub: [github.com/justrunme](https://github.com/justrunme)

---

## ✅ Example Commands

```bash
cra --interactive                 # Setup
cra my-new-app                   # Init
cra --platform=gitlab            # Use GitLab
cra --log 20                     # Show last 20 logs
cra --update                     # Update CLI
cra --remove                     # Untrack current folder
cra --sync-now                   # Force sync now
cra --version                    # Show version
```

---

📦 _Install. Run. Automate._  
🚀 **Welcome to DevOps Zen.**
```
