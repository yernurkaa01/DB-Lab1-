# Part 1: Key Identification Exercises

## Task 1.1 — Relation A: Employee

`Employee(EmpID, SSN, Email, Phone, Name, Department, Salary)`

### 1. Суперключи (минимум 6)
1. `{EmpID}`
2. `{SSN}`
3. `{Email}`
4. `{EmpID, SSN}`
5. `{EmpID, Name}`
6. `{SSN, Department}`
7. `{Email, Salary}`
8. `{EmpID, SSN, Email, Phone}`

### 2. Кандидатные ключи
`{EmpID}`, `{SSN}`, `{Email}`

`Phone` **не** является кандидатным ключом, несмотря на то что в примере данных значения уникальны — см. пункт 4.

### 3. Выбор Primary Key: `EmpID`

- **SSN** — персональные данные (PII), плохая практика для PK; может отсутствовать/меняться.
- **Email** — может меняться со временем (смена фамилии/домена компании).
- **EmpID** — внутренний неизменяемый системный идентификатор, не содержит чувствительной информации, гарантированно присутствует всегда.

### 4. Могут ли два сотрудника иметь одинаковый Phone?

Да. В приведённых данных телефоны случайно уникальны, но ничто в природе атрибута `Phone` (в отличие от `SSN`/`EmpID`/`Email`) не гарантирует это семантически — несколько сотрудников могут иметь общий рабочий/семейный номер. Уникальность *в текущем инстансе таблицы* ≠ уникальность *по определению атрибута*.

---

## Task 1.1 — Relation B: Course Registration

`Registration(StudentID, CourseCode, Section, Semester, Year, Grade, Credits)`

### 1. Минимальный Primary Key

```
{StudentID, CourseCode, Section, Semester, Year}
```

### 2. Почему каждый атрибут необходим

| Атрибут | Почему нужен в ключе |
|---|---|
| `StudentID` | разные студенты записываются на одну и ту же секцию/семестр |
| `CourseCode` | студент может учиться на нескольких курсах одновременно |
| `Section` | у одного курса может быть несколько секций (потоков) в один семестр |
| `Semester` | студент может пересдавать/повторно брать курс в другом семестре |
| `Year` | значение `Semester` (например "Fall") повторяется из года в год |

`Grade` и `Credits` — зависимые (неключевые) атрибуты.

### 3. Дополнительные кандидатные ключи

Других нет. `Credits` не является частью ключа и не кандидат: по правилу *"each course section in a semester has a fixed credit value"* атрибут `Credits` функционально зависит от `{CourseCode, Section, Semester, Year}` — это уже намёк на частичную зависимость, которая устраняется при нормализации (Part 4).

---

## Task 1.2 — Foreign Key Design (University System)

```
Student(StudentID, Name, Email, Major, AdvisorID)
Professor(ProfID, Name, Department, Salary)
Course(CourseID, Title, Credits, DepartmentCode)
Department(DeptCode, DeptName, Budget, ChairID)
Enrollment(StudentID, CourseID, Semester, Grade)
```

### Все foreign key связи

| # | FK (таблица.атрибут) | → Ссылается на | Смысл связи |
|---|---|---|---|
| 1 | `Student.AdvisorID` | → `Professor.ProfID` | у студента есть научный руководитель |
| 2 | `Course.DepartmentCode` | → `Department.DeptCode` | курс принадлежит кафедре |
| 3 | `Department.ChairID` | → `Professor.ProfID` | у кафедры есть заведующий |
| 4 | `Enrollment.StudentID` | → `Student.StudentID` | запись о зачислении → студент |
| 5 | `Enrollment.CourseID` | → `Course.CourseID` | запись о зачислении → курс |

**Итого 5 FK-связей.** Обрати внимание на взаимный цикл `Professor ↔ Department` (заведующий кафедры — профессор, при этом у профессора есть текстовое поле `Department` — по условию задачи оно не объявлено как FK на `DeptCode`, трактуем как обычный атрибут-название).
