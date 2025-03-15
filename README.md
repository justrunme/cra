# 🛠 create-repo

CLI-утилита для быстрой и автоматической инициализации, публикации и синхронизации Git-репозиториев (GitHub, GitLab, Bitbucket) с автослежением через cron (Linux) или launchd (macOS).

---

## 🚀 Возможности

- ✅ Автоопределение платформы (GitHub / GitLab / Bitbucket)
- ✅ Автоматическое создание удалённого репозитория
- ✅ Инициализация git, создание ветки `main` или `master`
- ✅ Автоопределение текущей ветки
- ✅ Автосоздание `.gitignore` и `README.md`
- ✅ Добавление проекта в список автослеживания `~/.repo-autosync.list`
- ✅ Поддержка `.env` файлов в проектах
- ✅ Автоматическая синхронизация через cron (или launchd/macOS)
- ✅ Красивый цветной вывод
- ✅ Поддержка командной работы (`--share`, `--team`, `--contributors`)
- ✅ Обновление утилиты через `--update`
- ✅ Уведомления (Linux, macOS, WSL)
- ✅ Логи: `~/.create-repo.log`, ошибки: `~/.create-repo-errors.log`

---

## 📦 Установка

### 📥 Linux (через .deb)

```bash
wget https://github.com/justrunme/cra/releases/latest/download/create-repo-auto_x.y.z.deb
sudo dpkg -i create-repo-auto_x.y.z.deb
```

### 🍏 macOS

```bash
curl -fsSL https://raw.githubusercontent.com/justrunme/cra/main/install-create-repo.sh | bash
```

---

## 🧠 Использование

```bash
create-repo [имя_репозитория] [опции]
```

Если имя не указано — используется текущая папка.

По умолчанию:

1. Определяется платформа (GitHub / GitLab / Bitbucket)
2. Создаётся репозиторий
3. Выполняется `commit`, `push`
4. Добавляется в `~/.repo-autosync.list`
5. Включается автосинхронизация (через cron или launchd)

---

## ⚙️ Аргументы

| Флаг             | Описание |
|------------------|----------|
| `--status`       | Показать статус cron/launchd и проекта |
| `--log [N]`      | Показать последние N строк лога |
| `--list`         | Список всех отслеживаемых репозиториев |
| `--remove`       | Удалить текущую папку из списка |
| `--clean`        | Удалить несуществующие пути из списка |
| `--share`        | Сгенерировать ссылку на проект и команду |
| `--contributors` | Показать список коммитеров проекта |
| `--team <имя>`   | Указать GitHub команду по умолчанию |
| `--update`       | Обновить утилиту через GitHub Releases |
| `--dry-run`      | Тестовый режим — ничего не пушится |
| `--version`      | Показать установленную версию |
| `--help`         | Показать справку |

---

## 🔁 Автосинхронизация

📌 Выполняется через:

- **Linux** — cron (`*/N * * * * /usr/local/bin/update-all`)
- **macOS** — launchd (`~/Library/LaunchAgents/com.create-repo.autosync.plist`)

Утилита `update-all`:

- Коммитит и пушит изменения
- Использует `.env` если он есть
- Определяет ветку (`main` / `master`)
- Ведёт лог и лог ошибок

---

## 🔧 Конфигурация (`~/.create-repo.conf`)

```ini
default_visibility=private
default_cron_interval=5
default_team=devops-team
```

---

## 🧩 Шаблоны

Можно создавать шаблоны:

```bash
~/.create-repo/templates/python.gitignore
~/.create-repo/templates/node.gitignore
```

И они будут применяться автоматически при наличии `main.py`, `package.json`, и т.д.

---

## 👥 Командная работа

| Функция | Команда |
|--------|---------|
| Сгенерировать ссылку | `create-repo --share` |
| Добавить команду GitHub | `create-repo --team devops` |
| Показать всех участников | `create-repo --contributors` |

---

## 📜 Логи

- ✅ Лог операций: `~/.create-repo.log`
- ❌ Лог ошибок: `~/.create-repo-errors.log`

---

## 🧪 Примеры

```bash
create-repo my-backend             # всё по умолчанию
create-repo --log 20               # посмотреть лог
create-repo --remove               # удалить из списка
create-repo --update               # обновить утилиту
create-repo --share --team devs    # включить команду
```

---

## ⚙️ Требования

| Компонент | Назначение |
|-----------|------------|
| `git`     | управление репозиториями |
| `gh`      | работа с GitHub (установи: `brew install gh` или `apt install gh`) |
| `curl`    | работа с GitLab / Bitbucket |
| `notify-send` / `osascript` / `powershell` | уведомления (опционально) |

---

## 💡 

- `--pull-only` — только git pull без push
- Автоопределение `.env`
- Расширенные шаблоны (`README.md`, `.gitignore`)
- GUI-интеграция (GitHub Desktop и т.д.)
- Автосборка `.deb` и `.pkg` через CI

---

## 🧠 Автор

**justrunme**  
🔗 GitHub: [github.com/justrunme](https://github.com/justrunme)

---

🧩 Хочешь внести вклад или предложить идею?  
Создай issue или используй `create-repo --interactive
