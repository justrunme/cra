🛠️ create-repo – CLI-инструмент для Git-инициализации, шаблонов и авто-синхронизации

create-repo — это Bash-утилита, которая позволяет за 1 шаг инициализировать Git-репозиторий, создать .gitignore и README.md по шаблону, опубликовать его на GitHub или GitLab и включить автоматическую синхронизацию с помощью cron.
✨ Возможности

    ✅ Автоопределение платформы (GitHub/GitLab)
    🧠 Работа с шаблонами .gitignore и README.md
    🔐 Публичные и приватные репозитории
    🌀 Авто-коммит и git push
    ⏱️ Cron-синхронизация каждые X минут
    💾 Отслеживание репозиториев в ~/.repo-autosync.list
    📦 Обновление через .deb
    🧪 Режим dry-run и интерактив
    🧹 Очистка неактуальных путей

🚀 Установка

    Готовый .deb можно скачать из релизов на GitHub

sudo dpkg -i create-repo-auto_*.deb

🧑‍💻 Использование

create-repo [имя-проекта] [опции]

Если имя не указано — используется текущая папка.
🔧 Опции
Флаг	Описание
--status	Показать статус cron и список отслеживаемых репозиториев
--log [N]	Показать последние N строк из лога ~/.create-repo.log
--clean	Удалить несуществующие пути из ~/.repo-autosync.list
--update	Скачать и установить последнюю версию .deb с GitHub
--dry-run	Проверка: не делает push и не добавляет cron
--interactive	Ввод данных вручную (платформа, интервал, приватность и др.)
-h, --help	Показать справку
📦 Пример

create-repo my-project

Создаёт публичный репозиторий my-project на GitHub, пушит и включает авто-синхронизацию каждые 1 минуту.
🧠 Конфигурация

Создай файл ~/.create-repo.conf и укажи настройки по умолчанию:

default_platform=github
default_cron_interval=5
default_visibility=private

📁 Шаблоны

Ты можешь использовать пользовательские шаблоны:

~/.create-repo/templates/github.README.md
~/.create-repo/templates/gitlab.gitignore

Они будут копироваться в новый проект автоматически.
🧹 Cron-очистка

Чтобы отключить синхронизацию:

crontab -l | grep -v update-all | crontab -

🔄 Обновление

create-repo --update

Скачивает последнюю версию .deb с GitHub и устанавливает.
🧪 Отладка и лог

create-repo --log 30

Покажет последние 30 строк из ~/.create-repo.log.
🧯 Удаление проекта из авто-слежения

sed -i "\\|/путь/к/проекту|d" ~/.repo-autosync.list

🤝 Поддержка

Проект на GitHub: github.com/justrunme/cra
