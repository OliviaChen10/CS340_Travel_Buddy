-- ============================================================
-- CS340 Travel Buddy — Data Manipulation Language (DML) Queries
-- Group 27: Olivia Chen and Hailey Mendenhall
-- ============================================================
-- Variables that are expected to be filled in by the back-end
-- (Node/Express) code before the query is sent to MySQL are
-- denoted using a colon prefix, e.g. :variableName
-- ============================================================


-- ============================================================
-- TRAVELERS
-- ============================================================

-- Get all travelers (Browse Travelers table)
SELECT travelerID, username, email
FROM Travelers;

-- Get a single traveler by ID (used to pre-fill the Update form)
SELECT travelerID, username, email
FROM Travelers
WHERE travelerID = :travelerID;

-- Add a new traveler (Create a Traveler form)
INSERT INTO Travelers (username, email)
VALUES (:usernameInput, :emailInput);

-- Update an existing traveler (Update a Traveler form)
UPDATE Travelers
SET username = :usernameInput,
    email = :emailInput
WHERE travelerID = :travelerIDInput;

-- Delete a traveler (Delete button)
DELETE FROM Travelers
WHERE travelerID = :travelerIDInput;


-- ============================================================
-- LOCATIONS
-- ============================================================

-- Get all locations (Browse Locations table)
SELECT locationID, countryName, continent
FROM Locations;

-- Get a single location by ID (used to pre-fill the Update form)
SELECT locationID, countryName, continent
FROM Locations
WHERE locationID = :locationID;

-- Add a new location (Create a Location form)
INSERT INTO Locations (countryName, continent)
VALUES (:countryNameInput, :continentInput);

-- Update an existing location (Update a Location form)
UPDATE Locations
SET countryName = :countryNameInput,
    continent = :continentInput
WHERE locationID = :locationIDInput;

-- Delete a location (Delete button)
DELETE FROM Locations
WHERE locationID = :locationIDInput;


-- ============================================================
-- TRAVELTYPES
-- ============================================================

-- Get all travel types (Browse Travel Types table)
SELECT typeID, travelName
FROM TravelTypes;

-- Get a single travel type by ID (used to pre-fill the Update form)
SELECT typeID, travelName
FROM TravelTypes
WHERE typeID = :typeID;

-- Add a new travel type (Create a Travel Type form)
INSERT INTO TravelTypes (travelName)
VALUES (:travelNameInput);

-- Update an existing travel type (Update a Travel Type form)
UPDATE TravelTypes
SET travelName = :travelNameInput
WHERE typeID = :typeIDInput;

-- Delete a travel type (Delete button)
DELETE FROM TravelTypes
WHERE typeID = :typeIDInput;


-- ============================================================
-- TRIPS
-- ============================================================

-- Get all trips (Browse Trips table)
SELECT tripID, startDate, endDate, travelerID, locationID
FROM Trips;

-- Get a single trip by ID (used to pre-fill the Update form)
SELECT tripID, startDate, endDate, travelerID, locationID
FROM Trips
WHERE tripID = :tripID;

-- Get all travelers, for the Traveler dropdown on the Create/Update Trip forms
SELECT travelerID, username
FROM Travelers;

-- Get all locations, for the Location dropdown on the Create/Update Trip forms
SELECT locationID, countryName
FROM Locations;

-- Add a new trip (Create a Trip form)
INSERT INTO Trips (startDate, endDate, travelerID, locationID)
VALUES (:startDateInput, :endDateInput, :travelerIDInput, :locationIDInput);

-- Update an existing trip (Update a Trip form)
UPDATE Trips
SET startDate = :startDateInput,
    endDate = :endDateInput,
    travelerID = :travelerIDInput,
    locationID = :locationIDInput
WHERE tripID = :tripIDInput;

-- Delete a trip (Delete button)
DELETE FROM Trips
WHERE tripID = :tripIDInput;


-- ============================================================
-- SEGMENTS
-- ============================================================

-- Get all segments (Browse Segments table)
SELECT segmentID, typeID, departureLocation, departureTime,
       arrivalLocation, arrivalTime, tripID
FROM Segments;

-- Get a single segment by ID (used to pre-fill the Update form)
SELECT segmentID, typeID, departureLocation, departureTime,
       arrivalLocation, arrivalTime, tripID
FROM Segments
WHERE segmentID = :segmentID;

-- Get all trips, for the Trip dropdown on the Create/Update Segment forms
SELECT tripID, startDate, endDate
FROM Trips;

-- Get all travel types, for the Travel Type dropdown on the
-- Create/Update Segment forms
SELECT typeID, travelName
FROM TravelTypes;

-- Add a new segment (Create a Segment form)
INSERT INTO Segments (typeID, departureLocation, departureTime,
                       arrivalLocation, arrivalTime, tripID)
VALUES (:typeIDInput, :departureLocationInput, :departureTimeInput,
        :arrivalLocationInput, :arrivalTimeInput, :tripIDInput);

-- Update an existing segment (Update a Segment form)
UPDATE Segments
SET typeID = :typeIDInput,
    departureLocation = :departureLocationInput,
    departureTime = :departureTimeInput,
    arrivalLocation = :arrivalLocationInput,
    arrivalTime = :arrivalTimeInput,
    tripID = :tripIDInput
WHERE segmentID = :segmentIDInput;

-- Delete a segment (Delete button)
DELETE FROM Segments
WHERE segmentID = :segmentIDInput;


-- ============================================================
-- ACTIVITIES
-- ============================================================

-- Get all activities (Browse Activities table)
SELECT activityID, activityName, activityType, tripID
FROM Activities;

-- Get a single activity by ID (used to pre-fill the Update form)
SELECT activityID, activityName, activityType, tripID
FROM Activities
WHERE activityID = :activityID;

-- Get all trips, for the Trip dropdown on the Create/Update Activity forms
SELECT tripID, startDate, endDate
FROM Trips;

-- Add a new activity (Create an Activity form)
INSERT INTO Activities (activityName, activityType, tripID)
VALUES (:activityNameInput, :activityTypeInput, :tripIDInput);

-- Update an existing activity (Update an Activity form)
UPDATE Activities
SET activityName = :activityNameInput,
    activityType = :activityTypeInput,
    tripID = :tripIDInput
WHERE activityID = :activityIDInput;

-- Delete an activity (Delete button)
DELETE FROM Activities
WHERE activityID = :activityIDInput;