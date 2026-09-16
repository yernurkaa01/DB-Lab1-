-- Task 4.1: StudentProject decomposed to 3NF

CREATE TABLE Student (
    StudentID       SERIAL PRIMARY KEY,
    StudentName     VARCHAR(100) NOT NULL,
    StudentMajor    VARCHAR(100)
);

CREATE TABLE Supervisor (
    SupervisorID    SERIAL PRIMARY KEY,
    SupervisorName  VARCHAR(100) NOT NULL,
    SupervisorDept  VARCHAR(100)
);

CREATE TABLE Project (
    ProjectID       SERIAL PRIMARY KEY,
    ProjectTitle    VARCHAR(200) NOT NULL,
    ProjectType     VARCHAR(50),
    SupervisorID    INT NOT NULL REFERENCES Supervisor(SupervisorID)
);

CREATE TABLE StudentProject (
    StudentID   INT NOT NULL REFERENCES Student(StudentID),
    ProjectID   INT NOT NULL REFERENCES Project(ProjectID),
    Role        VARCHAR(50),
    HoursWorked DECIMAL(6,1),
    StartDate   DATE,
    EndDate     DATE,
    PRIMARY KEY (StudentID, ProjectID)
);
