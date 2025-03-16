
# 🛠 create-repo

CLI-утилита для быстрой и автоматической инициализации, публикации и синхронизации Git-репозиториев (GitHub, GitLab, Bitbucket) с автослежением через **cron (Linux)** или **launchd (macOS)**. Поддерживает автообновление, автосборку `.deb` и `.pkg`, шаблоны и многое другое.

---

## 🚀 Возможности

- ✅ Интерактивный режим при первом запуске (`~/.create-repo.conf`)
- ✅ Автоопределение платформы (GitHub / GitLab / Bitbucket)
- ✅ Автоматическое создание удалённого репозитория
- ✅ Инициализация Git, создание ветки `main` или `master`
- ✅ Автоопределение текущей ветки
- ✅ Автосоздание `.gitignore` и `README.md`
- ✅ Добавление проекта в `~/.repo-autosync.list`
- ✅ Поддержка `.env` файлов
- ✅ Автосинхронизация через cron / launchd
- ✅ Цветной CLI-вывод и логгирование
- ✅ Командная работа (`--share`, `--team`, `--contributors`)
- ✅ Автообновление через `--update` (с проверкой версии)
- ✅ Интеграция с GitHub CLI (`gh`) и GUI-клиентами
- ✅ Уведомления (Linux, macOS, WSL)
- ✅ Автосборка `.deb` и `.pkg` через CI/CD

---

## 📦 Установка

### 📥 Linux (.deb)

```bash
wget https://github.com/justrunme/cra/releases/latest/download/create-repo-auto_x.y.z.deb
sudo dpkg -i create-repo-auto_x.y.z.deb
```

### 🍏 macOS (через установочный скрипт)

```bash
curl -fsSL https://raw.githubusercontent.com/justrunme/cra/main/install-create-repo.sh | bash
```

---

## 🧠 Использование

```bash
create-repo [имя_репозитория] [опции]
```

Если имя не указано — используется текущая папка.

---

## 🔄 Первый запуск

При первом запуске утилита задаст вам вопросы:

```
📦 Введите имя репозитория [my-folder]:
🔐 Выберите тип (public/private) [public]:
👥 Укажите команду GitHub (если есть) [none]:
⏱ Интервал автосинхронизации в минутах [1]:
```

Результат сохраняется в `~/.create-repo.conf`. Всё последующее поведение будет опираться на эти настройки.

---

## ⚙️ Аргументы

| Флаг             | Назначение |
|------------------|------------|
| `--interactive`  | Принудительный интерактивный режим |
| `--status`       | Статус cron / launchd |
| `--log [N]`      | Последние N строк лога |
| `--list`         | Все отслеживаемые проекты |
| `--remove`       | Удалить текущий проект из списка |
| `--clean`        | Очистить несуществующие пути |
| `--share`        | Ссылка на репозиторий и команду |
| `--team <имя>`   | Указать команду GitHub |
| `--contributors` | Показать всех коммитеров |
| `--update`       | Обновить утилиту до последней версии |
| `--pull-only`    | Только git pull (без push) |
| `--dry-run`      | Тестовый режим (без пуша) |
| `--version`      | Текущая версия утилиты |
| `--help`         | Справка по командам |

---

## 🔁 Автосинхронизация

### Linux (через `cron`):

```
*/N * * * * /usr/local/bin/update-all  # auto-sync by create-repo
```

### macOS (через `launchd`):

```
~/Library/LaunchAgents/com.create-repo.auto.plist
```

Фоновая утилита `update-all`:
- коммитит и пушит изменения,
- использует `.env`, если он есть,
- определяет активную ветку (main/master),
- ведёт лог: `~/.create-repo.log`, ошибки: `~/.create-repo-errors.log`

---

## 🔧 Конфигурация (`~/.create-repo.conf`)

```ini
# ~/.create-repo.conf — конфигурация утилиты create-repo

# 🔐 Тип репозитория: public / private
default_visibility=private

# ⏱ Интервал автосинхронизации в минутах
default_cron_interval=5

# 👥 Название команды GitHub (если используется)
default_team=devops-team
```

---

## 🧩 Шаблоны

Поддержка шаблонов `.gitignore` и `README.md`:

```bash
~/.create-repo/templates/python.gitignore
~/.create-repo/templates/node.gitignore
```

Утилита автоматически применяет шаблон, если в проекте найден файл вроде `main.py` или `package.json`.

---

## 🧪 CI/CD и тесты

✅ **Поддержка GitHub Actions**:
- автоматическая сборка `.deb` и `.pkg`
- smoke-тест перед релизом
- валидация
- changelog
- публикация в Release

✅ **Релизы**:
- Файлы: `.deb`, `.pkg`, `install-create-repo.sh`
- Автогенерация версии (vX.Y.Z)

---

## 👥 Командная работа

| Функция                 | Команда |
|-------------------------|---------|
| Сгенерировать ссылку    | `create-repo --share` |
| Указать команду GitHub  | `create-repo --team devops` |
| Посмотреть участников   | `create-repo --contributors` |

---

## 📜 Логи

| Файл                     | Назначение |
|--------------------------|------------|
| `~/.create-repo.log`     | Основной лог операций |
| `~/.create-repo-errors.log` | Ошибки (в том числе CI/CD) |

---

## 🧪 Примеры

```bash
create-repo my-app                 # создать репозиторий
create-repo --log 20              # последние 20 логов
create-repo --update              # обновить утилиту
create-repo --remove              # удалить из автослежения
create-repo --interactive         # повторный интерактив
create-repo --share --team devs   # генерация ссылки для команды
```

---

## ⚙️ Требования

| Утилита / CLI      | Назначение |
|---------------------|------------|
| `git`               | управление репозиториями |
| `gh`                | работа с GitHub |
| `curl`              | взаимодействие с GitLab и Bitbucket |
| `notify-send` / `osascript` | уведомления в GUI (Linux/macOS) |

---

## 💡 Полезности

- Автообновление через `--update`
- Поддержка `.env`, `.gitignore`, `README.md` и шаблонов
- Автоматическое определение платформы
- GUI-интеграция (GitHub Desktop и др.)
- CLI-алиас `cra`
- Автосборка `.deb` и `.pkg` через GitHub Actions

---

## 🧠 Автор

**justrunme**  
📦 GitHub: [github.com/justrunme](https://github.com/justrunme)

---

🙋‍♂️ **Есть идеи или улучшения?**
Создай issue или используй:

```bash
create-repo --interactive
```

---

📦 **Установи. Запусти. Наслаждайся автоматизацией.**  
🚀 _Welcome to DevOps Zen._

--- 
