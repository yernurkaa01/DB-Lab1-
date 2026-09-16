# Database Systems Laboratory Work — Week 2: Relational Model & Keys

Полное решение лабораторной работы: ключи и суперключи, ER-диаграммы, нормализация (1NF–BCNF), проектный челлендж.

## Структура репозитория

| Папка | Содержимое |
|---|---|
| `part1-keys/` | Part 1 — Superkeys, Candidate Keys, Foreign Keys |
| `part2-er-diagrams/` | Part 2 — ER-диаграммы (Hospital, E-commerce) + SQL-схемы |
| `part4-normalization/` | Part 4 — StudentProject (1NF→3NF) и CourseSchedule (BCNF) |
| `part5-design-challenge/` | Part 5 — Student Clubs System: ER + нормализованная схема + запросы |

## Как открыть SQL-файлы в DataGrip

1. Клонируй репозиторий: `git clone <URL_репозитория>`
2. Открой папку в DataGrip: **File → Open** → выбери папку `db-lab2-repo`
3. DataGrip сам подхватит `.sql` файлы как обычные SQL Scripts.
4. Чтобы реально выполнить DDL — создай Data Source (**Database panel → + → Data Source → PostgreSQL/SQLite**), затем открой нужный `.sql` файл и выполни через `Ctrl+Enter` / `⌘+Enter`, указав созданный Data Source как контекст (правый клик на файле → "Change Schema/Data Source").
5. Git-интеграция в DataGrip включается автоматически, если в папке есть `.git` (см. меню **Git** вверху, аналог Source Control в VS Code — там же Commit / Push / Pull).

## Примечание по Part 3

В присланных материалах преподавателя нумерация частей идёт Part 1 → Part 2 → Part 4 → Part 5 — Part 3 (Schema Mapping) в тексте задания отсутствует (страницы пропущены/не отправлены). Если у тебя есть материалы по Part 3 — пришли, дополню репозиторий.
