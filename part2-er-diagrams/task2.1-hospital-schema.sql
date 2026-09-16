-- Task 2.1: Hospital Management System
-- Реляционная схема, полученная из ER-диаграммы (task2.1-hospital.md)
-- Диалект: PostgreSQL (легко адаптируется под DataGrip / любой другой диалект)

CREATE TABLE Department (
    DeptCode    VARCHAR(10)  PRIMARY KEY,
    Name        VARCHAR(100) NOT NULL,
    Location    VARCHAR(100)
);

CREATE TABLE Doctor (
    DoctorID        SERIAL PRIMARY KEY,
    Name            VARCHAR(100) NOT NULL,
    Phone           VARCHAR(20),
    OfficeLocation  VARCHAR(100),
    DeptCode        VARCHAR(10) NOT NULL REFERENCES Department(DeptCode)
);

-- многозначный атрибут Doctor.Specializations -> отдельная таблица
CREATE TABLE DoctorSpecialization (
    DoctorID        INT NOT NULL REFERENCES Doctor(DoctorID) ON DELETE CASCADE,
    Specialization  VARCHAR(100) NOT NULL,
    PRIMARY KEY (DoctorID, Specialization)
);

CREATE TABLE Patient (
    PatientID           SERIAL PRIMARY KEY,
    Name                VARCHAR(100) NOT NULL,
    BirthDate            DATE NOT NULL,
    Street              VARCHAR(100),
    City                VARCHAR(50),
    State               VARCHAR(50),
    Zip                 VARCHAR(20),
    InsuranceProvider   VARCHAR(100),
    PolicyNumber        VARCHAR(50)
);

-- многозначный атрибут Patient.PhoneNumbers -> отдельная таблица
CREATE TABLE PatientPhone (
    PatientID   INT NOT NULL REFERENCES Patient(PatientID) ON DELETE CASCADE,
    Phone       VARCHAR(20) NOT NULL,
    PRIMARY KEY (PatientID, Phone)
);

-- weak entity Room, полный ключ (DeptCode, RoomNumber)
CREATE TABLE Room (
    DeptCode    VARCHAR(10) NOT NULL REFERENCES Department(DeptCode) ON DELETE CASCADE,
    RoomNumber  VARCHAR(10) NOT NULL,
    RoomType    VARCHAR(50),
    PRIMARY KEY (DeptCode, RoomNumber)
);

CREATE TABLE Appointment (
    AppointmentID   SERIAL PRIMARY KEY,
    PatientID       INT NOT NULL REFERENCES Patient(PatientID),
    DoctorID        INT NOT NULL REFERENCES Doctor(DoctorID),
    DeptCode        VARCHAR(10),
    RoomNumber      VARCHAR(10),
    AppointmentDate TIMESTAMP NOT NULL,
    Purpose         VARCHAR(200),
    Notes           TEXT,
    FOREIGN KEY (DeptCode, RoomNumber) REFERENCES Room(DeptCode, RoomNumber)
);

CREATE TABLE Prescription (
    PrescriptionID  SERIAL PRIMARY KEY,
    DoctorID        INT NOT NULL REFERENCES Doctor(DoctorID),
    PatientID       INT NOT NULL REFERENCES Patient(PatientID),
    Medication      VARCHAR(150) NOT NULL,
    Dosage          VARCHAR(100),
    Instructions    TEXT
);
