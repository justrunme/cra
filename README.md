# 🛠 create-repo

Автоматическая инициализация, публикация и синхронизация Git-репозиториев (GitHub / GitLab / Bitbucket) с автослежением через cron.  
Подходит как для соло-разработчиков, так и для командной работы.

---

## 🚀 Возможности

- 🔧 Инициализация git-репозитория и создание ветки `main`
- 🌐 Определение и подключение к GitHub, GitLab или Bitbucket
- ☁️ Автоматическое создание удалённого репозитория
- 🌀 Первый commit, push и отслеживание
- ⏱ Автосинхронизация с помощью `cron`
- 📁 Поддержка шаблонов `.gitignore`, `README.md`
- 🛠 Конфигурация через `~/.create-repo.conf`
- 🔔 Уведомления через `notify-send` (если доступно)
- 👥 Поддержка командной работы (`--team`, `--share`, `--contributors`)
- 🔁 Автообновление .deb-пакета через `--update`

---

## 📦 Установка

```bash
wget https://github.com/justrunme/cra/releases/latest/download/create-repo-auto_x.y.z.deb
sudo dpkg -i create-repo-auto_x.y.z.deb
```

После установки доступны команды:

- `create-repo` — основной CLI
- `update-all` — синхронизация через cron

---

## ⚙️ Использование

```bash
create-repo [имя_папки] [опции]
```

Если имя не указано — используется текущая директория.

🔧 Пример:

```bash
create-repo my-api --team devs --share
```

---

## 🧠 Опции

| Флаг               | Назначение |
|--------------------|------------|
| `--status`         | Статус cron, последняя активность и тек. проект |
| `--log [N]`        | Показать последние N строк лога |
| `--list`           | Показать все отслеживаемые проекты |
| `--remove`         | Удалить текущую папку из отслеживания |
| `--clean`          | Удалить несуществующие пути из списка |
| `--share`          | Показать ссылку на репозиторий |
| `--contributors`   | Показать список участников проекта |
| `--team NAME`      | Указать команду GitHub при создании |
| `--update`         | Обновить до последней версии из GitHub |
| `--dry-run`        | Только показать, что будет сделано |
| `--version`        | Показать версию |
| `--help`           | Показать справку |

---

## 🔁 Автосинхронизация

Каждую минуту (или указанное значение) выполняется:

```bash
/usr/local/bin/update-all
```

И происходит:

- `git add .`
- `git commit -m "Auto commit"`
- `git pull --rebase`
- `git push`

📍 Список проектов: `~/.repo-autosync.list`  
📜 Лог: `~/.create-repo.log`  
🐞 Ошибки: `~/.create-repo-errors.log`

---

## 🧩 Конфигурация (`~/.create-repo.conf`)

```ini
default_visibility=private
default_cron_interval=5
default_team=my-team
```

---

## 🧰 Дополнительно

- 🧪 `--dry-run` не делает действий, только показывает план
- 🧠 Используется шаблон по языку, если найден `.py`, `package.json` и т.д.
- 🔐 Репозитории создаются приватными, если указано в конфиге
- 💬 Уведомления доступны через `notify-send` (опционально)

---

## 📘 Примеры

```bash
create-repo              # Просто инициирует и синхронизирует текущую папку
create-repo --status     # Покажет статус текущего проекта
create-repo --log 5      # Последние 5 строк лога
create-repo --list       # Все отслеживаемые проекты
create-repo --remove     # Удалить текущий из отслеживания
create-repo --update     # Обновиться до последней версии
create-repo --share      # Показать ссылку на репозиторий
create-repo --contributors  # Список участников (по коммитам)
```

---

## 💡

- `--pull-only` — только `git pull`, без `commit/push`
- Поддержка `.env` из директории проекта
- Автоопределение `main`/`master`
- Расширенная поддержка `.create-repo-errors.log`

---

## 🧪 Требования

- `git`
- `curl`
- `gh` (для GitHub) — `sudo apt install gh && gh auth login`
- `notify-send` (опционально)

---

## 📬 Автор

**justrunme**  
GitHub: [github.com/justrunme](https://github.com/justrunme)

---

С любовью ❤️ к автоматизации.
```
