-- Task 5.1: Student Clubs System — normalized (3NF) relational schema

CREATE TABLE Student (
    StudentID   SERIAL PRIMARY KEY,
    Name        VARCHAR(100) NOT NULL,
    Email       VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE Advisor (
    AdvisorID   SERIAL PRIMARY KEY,
    Name        VARCHAR(100) NOT NULL,
    Department  VARCHAR(100)
);

CREATE TABLE Club (
    ClubID      SERIAL PRIMARY KEY,
    Name        VARCHAR(150) NOT NULL,
    Description TEXT,
    Budget      DECIMAL(12,2) DEFAULT 0,
    AdvisorID   INT NOT NULL REFERENCES Advisor(AdvisorID)
);

CREATE TABLE Membership (
    StudentID   INT NOT NULL REFERENCES Student(StudentID),
    ClubID      INT NOT NULL REFERENCES Club(ClubID),
    Role        VARCHAR(50) NOT NULL DEFAULT 'member',
    JoinDate    DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (StudentID, ClubID)
);

CREATE TABLE Event (
    EventID     SERIAL PRIMARY KEY,
    ClubID      INT NOT NULL REFERENCES Club(ClubID),
    EventName   VARCHAR(150) NOT NULL,
    EventDate   TIMESTAMP NOT NULL,
    Purpose     VARCHAR(200)
);

CREATE TABLE Attendance (
    StudentID   INT NOT NULL REFERENCES Student(StudentID),
    EventID     INT NOT NULL REFERENCES Event(EventID),
    Status      VARCHAR(20) NOT NULL DEFAULT 'registered',
    PRIMARY KEY (StudentID, EventID)
);

CREATE TABLE RoomReservation (
    EventID     INT PRIMARY KEY REFERENCES Event(EventID),
    Room        VARCHAR(20) NOT NULL,
    Building    VARCHAR(50) NOT NULL,
    TimeSlot    VARCHAR(30) NOT NULL
);

CREATE TABLE Expense (
    ExpenseID   SERIAL PRIMARY KEY,
    ClubID      INT NOT NULL REFERENCES Club(ClubID),
    Amount      DECIMAL(10,2) NOT NULL,
    ExpenseDate DATE NOT NULL DEFAULT CURRENT_DATE,
    Description VARCHAR(200)
);
