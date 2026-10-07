-- Task 4.2: CourseSchedule decomposed to BCNF

CREATE TABLE Student (
    StudentID       SERIAL PRIMARY KEY,
    StudentMajor    VARCHAR(100)
);

CREATE TABLE Course (
    CourseID    VARCHAR(20) PRIMARY KEY,
    CourseName  VARCHAR(150) NOT NULL
);

CREATE TABLE Instructor (
    InstructorID    SERIAL PRIMARY KEY,
    InstructorName  VARCHAR(100) NOT NULL
);

CREATE TABLE RoomInfo (
    Room        VARCHAR(20) PRIMARY KEY,
    Building    VARCHAR(50) NOT NULL
);

-- Два кандидатных ключа: (CourseID, TimeSlot) и (Room, TimeSlot)
CREATE TABLE Section (
    CourseID        VARCHAR(20) NOT NULL REFERENCES Course(CourseID),
    TimeSlot        VARCHAR(30) NOT NULL,
    InstructorID    INT NOT NULL REFERENCES Instructor(InstructorID),
    Room            VARCHAR(20) NOT NULL REFERENCES RoomInfo(Room),
    PRIMARY KEY (CourseID, TimeSlot),
    UNIQUE (Room, TimeSlot)          -- второй кандидатный ключ
);

CREATE TABLE Enrollment (
    StudentID   INT NOT NULL REFERENCES Student(StudentID),
    CourseID    VARCHAR(20) NOT NULL,
    TimeSlot    VARCHAR(30) NOT NULL,
    PRIMARY KEY (StudentID, CourseID, TimeSlot),
    FOREIGN KEY (CourseID, TimeSlot) REFERENCES Section(CourseID, TimeSlot)
);
