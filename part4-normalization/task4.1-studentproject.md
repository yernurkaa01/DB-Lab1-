# Task 4.1 — Denormalized Table Analysis: StudentProject

```
StudentProject(StudentID, StudentName, StudentMajor, ProjectID, ProjectTitle,
               ProjectType, SupervisorID, SupervisorName, SupervisorDept,
               Role, HoursWorked, StartDate, EndDate)
```

Предполагаемый Primary Key: **`(StudentID, ProjectID)`** — один студент может работать над несколькими проектами, у одного проекта может быть несколько студентов; `Role`/`HoursWorked`/`StartDate`/`EndDate` специфичны именно для *данной пары* студент-проект.

## 1. Функциональные зависимости (FD)

```
StudentID              → StudentName, StudentMajor
ProjectID              → ProjectTitle, ProjectType, SupervisorID
SupervisorID           → SupervisorName, SupervisorDept
(StudentID, ProjectID) → Role, HoursWorked, StartDate, EndDate
```

Транзитивная связь: `ProjectID → SupervisorID → SupervisorName, SupervisorDept`

## 2. Проблемы избыточности

**Избыточность:**
- `StudentName`, `StudentMajor` дублируются в каждой строке для каждого проекта студента
- `ProjectTitle`, `ProjectType`, `SupervisorID` дублируются для каждого студента, участвующего в проекте
- `SupervisorName`, `SupervisorDept` дублируются для каждого проекта, которым руководит данный supervisor

**Аномалии:**
- **Update anomaly**: смена специальности студента (`StudentMajor`) требует обновления *всех* строк, где встречается этот студент — риск рассинхронизации, если обновить не все строки.
- **Insert anomaly**: нельзя добавить новый проект без назначения хотя бы одного студента, так как `StudentID` — часть PK. Аналогично нельзя завести supervisor'а без привязки к проекту.
- **Delete anomaly**: если удалить единственную строку студент-проект для конкретного проекта (например, студент отчислился), теряется информация о самом проекте (`ProjectTitle`, `ProjectType`, `SupervisorID`) целиком.

## 3. Применяем 1NF

Все атрибуты уже атомарны (нет повторяющихся групп/многозначных полей) — **нарушений 1NF нет**.

## 4. Применяем 2NF

PK = `(StudentID, ProjectID)` — составной. Частичные зависимости:
- `StudentID → StudentName, StudentMajor` (зависит только от части ключа)
- `ProjectID → ProjectTitle, ProjectType, SupervisorID` (зависит только от части ключа)

### 2NF-декомпозиция

```
Student(StudentID, StudentName, StudentMajor)
Project(ProjectID, ProjectTitle, ProjectType, SupervisorID)
StudentProject(StudentID, ProjectID, Role, HoursWorked, StartDate, EndDate)
```

## 5. Применяем 3NF

В таблице `Project` остаётся транзитивная зависимость:
`ProjectID → SupervisorID → SupervisorName, SupervisorDept`
(`SupervisorName`/`SupervisorDept` зависят от `SupervisorID`, а не напрямую от `ProjectID`)

### Финальная 3NF-декомпозиция

```
Student(StudentID, StudentName, StudentMajor)
    PK: StudentID

Supervisor(SupervisorID, SupervisorName, SupervisorDept)
    PK: SupervisorID

Project(ProjectID, ProjectTitle, ProjectType, SupervisorID)
    PK: ProjectID
    FK: SupervisorID → Supervisor(SupervisorID)

StudentProject(StudentID, ProjectID, Role, HoursWorked, StartDate, EndDate)
    PK: (StudentID, ProjectID)
    FK: StudentID → Student(StudentID)
    FK: ProjectID → Project(ProjectID)
```

Декомпозиция без потерь (lossless-join): на каждом шаге разбиение шло по общему атрибуту-ключу (`StudentID`, `ProjectID`, `SupervisorID`), что гарантирует восстановление исходной таблицы через JOIN.
