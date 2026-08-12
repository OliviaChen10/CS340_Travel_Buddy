-- ============================================================
-- CS340 Project - DDL.sql
-- Team members: Hailey Mendenhall, Olivia Chen
-- Group Number 27
-- Description: Creates and populates the Travel Planner database
--   schema (Travelers, Locations, Trips, TravelTypes, Segments,
--   Activities) with sample data as shown in the project report.
-- ============================================================
 
-- Disable foreign key checks and autocommit while we rebuild
-- the schema, to avoid ordering/import errors.
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT=0;
 
-- ------------------------------------------------------------
-- Drop tables if they already exist (children first, to avoid
-- FK errors even though FK checks are disabled -- keeps the
-- file safe to run in other contexts too).
-- ------------------------------------------------------------
DROP TABLE IF EXISTS Activities;
DROP TABLE IF EXISTS Segments;
DROP TABLE IF EXISTS TravelTypes;
DROP TABLE IF EXISTS Trips;
DROP TABLE IF EXISTS Locations;
DROP TABLE IF EXISTS Travelers;
 
-- ------------------------------------------------------------
-- Table: Travelers
-- Stores the individual users/travelers who create trips.
-- ------------------------------------------------------------
CREATE TABLE Travelers (
    travelerID INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (travelerID),
    CONSTRAINT uq_traveler_username UNIQUE (username),
    CONSTRAINT uq_traveler_email UNIQUE (email)
);
 
-- ------------------------------------------------------------
-- Table: Locations
-- Stores destination countries and their continent.
-- ------------------------------------------------------------
CREATE TABLE Locations (
    locationID INT NOT NULL AUTO_INCREMENT,
    countryName VARCHAR(100) NOT NULL UNIQUE,
    continent VARCHAR(45) NOT NULL,
    PRIMARY KEY (locationID),
	CONSTRAINT uq_location_country UNIQUE (countryName)
);
 
-- ------------------------------------------------------------
-- Table: TravelTypes
-- Lookup table for the mode of transportation used in a Segment
-- (Plane, Boat, Train, Car, etc).
-- ------------------------------------------------------------
CREATE TABLE TravelTypes (
    typeID INT NOT NULL AUTO_INCREMENT,
    travelName VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (typeID)
);
 
-- ------------------------------------------------------------
-- Table: Trips
-- Intersection table linking one Traveler to one Location for a
-- specific date range. Each Trip belongs to exactly one
-- Traveler and one Location (1:M from each parent into Trips).
-- ------------------------------------------------------------
CREATE TABLE Trips (
    tripID INT NOT NULL AUTO_INCREMENT,
    tripName VARCHAR(250) UNIQUE,
    startDate DATE	NOT NULL,
    endDate DATE NOT NULL,
    travelerID INT NOT NULL,
    locationID INT NOT NULL,
    PRIMARY KEY (tripID),
    FOREIGN KEY (travelerID) REFERENCES Travelers(travelerID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (locationID) REFERENCES Locations(locationID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
 
-- ------------------------------------------------------------
-- Table: Segments
-- Individual legs of travel (plane/boat/train/car, etc) that
-- make up a Trip. Each Segment belongs to exactly one Trip and
-- references one TravelType.
-- ------------------------------------------------------------
CREATE TABLE Segments (
    segmentID INT NOT NULL AUTO_INCREMENT,
    typeID INT NOT NULL,
    departureLocation VARCHAR(150) NOT NULL,
    departureTime DATETIME NOT NULL,
    arrivalLocation VARCHAR(150) NOT NULL,
    arrivalTime DATETIME NOT NULL,
    tripID INT NOT NULL,
    PRIMARY KEY (segmentID),
    FOREIGN KEY (typeID) REFERENCES TravelTypes(typeID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (tripID) REFERENCES Trips(tripID)
        ON UPDATE CASCADE ON DELETE CASCADE
);
 
-- ------------------------------------------------------------
-- Table: Activities
-- Excursions/activities planned during a Trip. Each Activity
-- belongs to exactly one Trip.
-- ------------------------------------------------------------
CREATE TABLE Activities (
    activityID INT NOT NULL AUTO_INCREMENT,
    activityName VARCHAR(150) NOT NULL,
    activityType VARCHAR(50),
    tripID INT NOT NULL,
    PRIMARY KEY (activityID),
    FOREIGN KEY (tripID) REFERENCES Trips(tripID)
        ON UPDATE CASCADE ON DELETE CASCADE
);
 
-- ============================================================
-- SAMPLE DATA (from the Example Data section of the report)
-- ============================================================
 
-- Travelers
INSERT INTO Travelers (username, email) VALUES
('skylark', 'flyhigh@gmail.com'),
('traveler1', 'trv.1@hotmail.com'),
('vacaytime', 'travelmaniac42@yahoo.com'),
('escapist33', 'e33@protonmail.com');
 
-- Locations
INSERT INTO Locations (countryName, continent) VALUES
('Canada', 'North America'),
('Iceland', 'Europe'),
('Colombia', 'South America'),
('Japan', 'Asia');
 
-- TravelTypes
INSERT INTO TravelTypes (travelName) VALUES
('Plane'),
('Boat'),
('Train'),
('Car');
 
-- Trips
INSERT INTO Trips (tripName, startDate, endDate, travelerID, locationID) VALUES
('Canadia :D', '2026-03-15', '2026-03-21', 1, 1),
('Japan Trip!!!!', '2026-01-10', '2026-01-17', 3, 4),
('Colombian Coffee Trip', '2025-07-01', '2025-07-04', 4, 3),
('Black sand beaches!', '2025-05-16', '2025-05-19', 1, 2),
('Ice Hockey', '2024-09-20', '2024-10-20', 2, 1);
 
-- Segments
-- (departure/arrival dates are anchored to each segment's parent
-- Trip's startDate; the boat segment's arrival rolls to the next
-- calendar day since it arrives at 9:00 after a 19:00 departure)
INSERT INTO Segments (typeID, departureLocation, departureTime, arrivalLocation, arrivalTime, tripID) VALUES
(1, 'SFO', '2026-01-10 11:30:00', 'HND', '2026-01-10 15:15:00', 2),
(2, 'Shinko Wharf', '2026-01-10 19:00:00', 'Okinawa', '2026-01-11 09:00:00', 2),
(3, 'LGA', '2026-03-15 08:00:00', 'YYZ', '2026-03-15 13:45:00', 1),
(4, 'Caracas', '2025-07-01 06:00:00', 'Bogota', '2025-07-02 16:00:00', 3);
 
-- Activities
INSERT INTO Activities (activityName, activityType, tripID) VALUES
('Biking', 'Excursion', 1),
('Hiking', 'Excursion', 1),
('Swimming', 'Relaxing', 4),
('Museum', 'Excursion', 2);
 
-- ------------------------------------------------------------
-- Re-enable checks and commit everything
-- ------------------------------------------------------------
SET FOREIGN_KEY_CHECKS=1;
COMMIT;