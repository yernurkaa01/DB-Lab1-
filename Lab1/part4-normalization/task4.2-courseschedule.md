# Task 4.2 — Advanced Normalization: CourseSchedule

```
CourseSchedule(StudentID, StudentMajor, CourseID, CourseName,
               InstructorID, InstructorName, TimeSlot, Room, Building)
```

**Business Rules:**
- Each student has exactly one major → `StudentID → StudentMajor`
- Each course has a fixed name → `CourseID → CourseName`
- Each instructor has exactly one name → `InstructorID → InstructorName`
- Rooms are unique across campus → `Room → Building`
- Each course section is taught by one instructor at one time in one room → `(CourseID, TimeSlot) → InstructorID, Room`
- Room+time physically can only host one class → `(Room, TimeSlot) → CourseID, InstructorID`
- A student can be enrolled in multiple course sections

## 1. Primary Key (hint: tricky!)

Таблица не содержит атрибута `Semester`, значит предполагаем, что курс проводится единожды за рассматриваемый период, но **может иметь несколько секций** (разные `TimeSlot`/`Room`/`Instructor` для одного `CourseID`). Студент может быть записан на разные секции разных курсов — но не может дважды быть записан на один и тот же `(CourseID, TimeSlot)`.

**Primary Key = `(StudentID, CourseID, TimeSlot)`**

Это "хитрый" момент: интуитивно кажется, что достаточно `(StudentID, CourseID)`, но так как курс может иметь несколько секций (разное `TimeSlot`), для однозначной идентификации *конкретной посещаемой секции* нужен ещё и `TimeSlot`.

## 2. Функциональные зависимости

```
StudentID              → StudentMajor                      (частичная)
CourseID               → CourseName                        (частичная)
InstructorID           → InstructorName                    (транзитивная)
Room                   → Building                           (транзитивная)
(CourseID, TimeSlot)   → InstructorID, Room                (частичная)
(Room, TimeSlot)       → CourseID, InstructorID             (не входит в PK вообще!)
```

## 3. Проверка BCNF

Правило BCNF: **для каждой FD X → Y, X должен быть суперключом**.

| FD | X — суперключ? | BCNF? |
|---|---|---|
| `StudentID → StudentMajor` | нет | ❌ нарушение |
| `CourseID → CourseName` | нет | ❌ нарушение |
| `InstructorID → InstructorName` | нет | ❌ нарушение |
| `Room → Building` | нет | ❌ нарушение |
| `(CourseID, TimeSlot) → InstructorID, Room` | нет (не хватает StudentID) | ❌ нарушение |
| `(Room, TimeSlot) → CourseID, InstructorID` | нет | ❌ нарушение |

**Таблица не в BCNF** (и даже не в 3NF/2NF).

## 4. Декомпозиция до BCNF (пошагово, алгоритм "разбить по нарушающей FD")

**Шаг 1.** Нарушение `StudentID → StudentMajor`:
```
Student(StudentID, StudentMajor)                                    ✅ BCNF
Остаток: (StudentID, CourseID, CourseName, InstructorID,
          InstructorName, TimeSlot, Room, Building)
```

**Шаг 2.** Нарушение `CourseID → CourseName`:
```
Course(CourseID, CourseName)                                        ✅ BCNF
Остаток: (StudentID, CourseID, InstructorID, InstructorName,
          TimeSlot, Room, Building)
```

**Шаг 3.** Нарушение `InstructorID → InstructorName`:
```
Instructor(InstructorID, InstructorName)                            ✅ BCNF
Остаток: (StudentID, CourseID, InstructorID, TimeSlot, Room, Building)
```

**Шаг 4.** Нарушение `Room → Building`:
```
RoomInfo(Room, Building)                                            ✅ BCNF
Остаток: (StudentID, CourseID, InstructorID, TimeSlot, Room)
```

**Шаг 5.** В остатке `(StudentID, CourseID, InstructorID, TimeSlot, Room)` держится
`(CourseID, TimeSlot) → InstructorID, Room` — не суперключ остатка (не хватает StudentID). Разбиваем:
```
Section(CourseID, TimeSlot, InstructorID, Room)
Enrollment(StudentID, CourseID, TimeSlot)
```

**Проверка `Section`:** здесь также верна FD `(Room, TimeSlot) → CourseID, InstructorID` — то есть `(Room, TimeSlot)` тоже является ключом-кандидатом для `Section` (двузначный ключ: либо `(CourseID, TimeSlot)`, либо `(Room, TimeSlot)`, оба определяют все атрибуты). Все детерминанты — суперключи → **`Section` в BCNF**.

**Проверка `Enrollment`:** весь набор атрибутов = ключ, нетривиальных FD нет → **BCNF тривиально**.

## 5. Финальная BCNF-декомпозиция

```
Student(StudentID, StudentMajor)                       PK: StudentID
Course(CourseID, CourseName)                            PK: CourseID
Instructor(InstructorID, InstructorName)                PK: InstructorID
RoomInfo(Room, Building)                                 PK: Room
Section(CourseID, TimeSlot, InstructorID, Room)          PK: (CourseID, TimeSlot)   [alt key: (Room, TimeSlot)]
Enrollment(StudentID, CourseID, TimeSlot)                 PK: (StudentID, CourseID, TimeSlot)
```

## 6. Потеря информации при декомпозиции

- **Lossless-join сохранён**: на каждом шаге алгоритма разбиение шло строго по общему атрибуту-детерминанту нарушающей FD, что математически гарантирует безпотерьное соединение (стандартное свойство BCNF-алгоритма).
- **Dependency preservation** — интересный случай: обычно BCNF-декомпозиция может терять сохранение зависимостей, но здесь **все исходные FD проверяемы** в декомпозированных таблицах без необходимости JOIN:
  - `StudentID → StudentMajor` — проверяется в `Student` ✅
  - `CourseID → CourseName` — в `Course` ✅
  - `InstructorID → InstructorName` — в `Instructor` ✅
  - `Room → Building` — в `RoomInfo` ✅
  - `(CourseID,TimeSlot) → InstructorID, Room` — в `Section` ✅
  - `(Room,TimeSlot) → CourseID, InstructorID` — тоже в `Section` (это второй ключ-кандидат таблицы) ✅

  Таким образом, для *этого конкретного набора* FD декомпозиция получилась одновременно lossless-join **и** dependency-preserving — что не всегда достижимо для BCNF в общем случае.
