-- ### Citation for implementing CRUD operations
-- Date retrieved: 8/4/26
-- Based on the directions/code from Oregon State CS340 Exploration - Implementing CUD operations in your app. Wrote stored procedures and route handler code using node.js instructions.
-- URL: https://canvas.oregonstate.edu/courses/2051721/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26923368

-- #############################
-- RESET to all sample data in our DDL.sql
-- #############################
DROP PROCEDURE IF EXISTS sp_resetDatabase;

DELIMITER //
CREATE PROCEDURE sp_resetDatabase()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;

    -- ------------------------------------------------------------
    -- Drop tables if they already exist (children first)
    -- ------------------------------------------------------------
    DROP TABLE IF EXISTS Activities;
    DROP TABLE IF EXISTS Segments;
    DROP TABLE IF EXISTS TravelTypes;
    DROP TABLE IF EXISTS Trips;
    DROP TABLE IF EXISTS Locations;
    DROP TABLE IF EXISTS Travelers;

    -- ------------------------------------------------------------
    -- Table: Travelers
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
    -- ------------------------------------------------------------
    CREATE TABLE TravelTypes (
        typeID INT NOT NULL AUTO_INCREMENT,
        travelName VARCHAR(50) NOT NULL,
        PRIMARY KEY (typeID),
        CONSTRAINT uq_traveltype_name UNIQUE (travelName)
    );

    -- ------------------------------------------------------------
    -- Table: Trips
    -- ------------------------------------------------------------
    CREATE TABLE Trips (
        tripID INT NOT NULL AUTO_INCREMENT,
        tripName VARCHAR(250) UNIQUE,
        startDate DATE NOT NULL,
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
    -- SAMPLE DATA
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

    SET FOREIGN_KEY_CHECKS = 1;
END //
DELIMITER ;



-- #############################
-- CREATE traveler
-- #############################

DROP PROCEDURE IF EXISTS sp_createTraveler;

DELIMITER //
CREATE PROCEDURE sp_createTraveler(
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(100),
    OUT p_travelerID INT
)

BEGIN
    INSERT INTO Travelers (username, email)
    VALUES (p_username, p_email);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_travelerID;
    -- Display the ID of the last inserted person
    SELECT LAST_INSERT_ID() as 'newID';

END //
DELIMITER ;


-- #############################
-- CREATE segment
-- #############################
DROP PROCEDURE IF EXISTS sp_createSegment;

DELIMITER //
CREATE PROCEDURE sp_createSegment(
    IN p_typeID INT,
    IN p_departureLocation VARCHAR(150),
    IN p_departureTime DATETIME,
    IN p_arrivalLocation VARCHAR(150),
    IN p_arrivalTime DATETIME,
    IN p_tripID INT,
    OUT p_segmentID INT
)

BEGIN
    INSERT INTO Segments (typeID, departureLocation, departureTime, arrivalLocation, arrivalTime, tripID)
    VALUES (p_typeID, p_departureLocation, p_departureTime, p_arrivalLocation, p_arrivalTime, p_tripID);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_segmentID;
    -- Display the ID of the last inserted person
    SELECT LAST_INSERT_ID() as 'newID';

END //
DELIMITER ;


-- #############################
-- CREATE trip
-- #############################
DROP PROCEDURE IF EXISTS sp_createTrip;

DELIMITER //
CREATE PROCEDURE sp_createTrip(
    IN p_tripName VARCHAR(250),
    IN p_startDate DATE,
    IN p_endDate DATE,
    IN p_travelerID INT,
    IN p_locationID INT,
    OUT p_tripID INT
)

BEGIN
    INSERT INTO Trips (tripName, startDate, endDate, travelerID, locationID)
    VALUES (p_tripName, p_startDate, p_endDate, p_travelerID, p_locationID);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_tripID;
    -- Display the ID of the last inserted person
    SELECT LAST_INSERT_ID() as 'newID';

END //
DELIMITER ;


-- #############################
-- CREATE travelType
-- #############################
DROP PROCEDURE IF EXISTS sp_createTravelType;

DELIMITER //
CREATE PROCEDURE sp_createTravelType(
    IN p_travelName VARCHAR(50),
    OUT p_travelTypeID INT
)

BEGIN
    INSERT INTO TravelTypes (travelName)
    VALUES (p_travelName);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_travelTypeID;
    -- Display the ID of the last inserted person
    SELECT LAST_INSERT_ID() as 'newID';

END //
DELIMITER ;


-- #############################
-- CREATE location
-- #############################
DROP PROCEDURE IF EXISTS sp_createLocation;

DELIMITER //
CREATE PROCEDURE sp_createLocation(
    IN p_countryName VARCHAR(100),
    IN p_continent VARCHAR(45),
    OUT p_locationID INT
)

BEGIN
    INSERT INTO Locations (countryName, continent)
    VALUES (p_countryName, p_continent);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_locationID;
    -- Display the ID of the last inserted person
    SELECT LAST_INSERT_ID() as 'newID';

END //
DELIMITER ;

-- #############################
-- CREATE activity
-- #############################
DROP PROCEDURE IF EXISTS sp_createActivity;

DELIMITER //
CREATE PROCEDURE sp_createActivity(
    IN p_activityName VARCHAR(150),
    IN p_cactivityType VARCHAR(50),
    IN p_tripID INT,
    OUT p_activityID INT
)

BEGIN
    INSERT INTO Activities (activityName, activityType, tripID)
    VALUES (p_activityName, p_cactivityType, p_tripID);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_activityID;
    -- Display the ID of the last inserted person
    SELECT LAST_INSERT_ID() as 'newID';

END //
DELIMITER ;

-- #############################
-- UPDATE traveler
-- #############################
DROP PROCEDURE IF EXISTS sp_updateTraveler;

DELIMITER //
CREATE PROCEDURE sp_updateTraveler(
    IN p_travelerID INT,
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        UPDATE Travelers
        SET username = p_username,
            email = p_email
        WHERE travelerID = p_travelerID;

        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching traveler found for id: ', p_travelerID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    COMMIT;
END //
DELIMITER ;


-- #############################
-- UPDATE location
-- #############################
DROP PROCEDURE IF EXISTS sp_updateLocation;

DELIMITER //
CREATE PROCEDURE sp_updateLocation(
    IN p_locationID INT,
    IN p_countryName VARCHAR(100),
    IN p_continent VARCHAR(45)
)
BEGIN
    DECLARE error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        UPDATE Locations
        SET countryName = p_countryName,
            continent = p_continent
        WHERE locationID = p_locationID;

        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching location found for id: ', p_locationID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    COMMIT;
END //
DELIMITER ;


-- #############################
-- UPDATE travelType
-- #############################
DROP PROCEDURE IF EXISTS sp_updateTravelType;

DELIMITER //
CREATE PROCEDURE sp_updateTravelType(
    IN p_typeID INT,
    IN p_travelName VARCHAR(50)
)
BEGIN
    DECLARE error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        UPDATE TravelTypes
        SET travelName = p_travelName
        WHERE typeID = p_typeID;

        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching travel type found for id: ', p_typeID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    COMMIT;
END //
DELIMITER ;


-- #############################
-- UPDATE trip
-- #############################
DROP PROCEDURE IF EXISTS sp_updateTrip;

DELIMITER //
CREATE PROCEDURE sp_updateTrip(
    IN p_tripID INT,
    IN p_tripName VARCHAR(250),
    IN p_startDate DATE,
    IN p_endDate DATE,
    IN p_travelerID INT,
    IN p_locationID INT
)
BEGIN
    DECLARE error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        UPDATE Trips
        SET tripName = p_tripName,
            startDate = p_startDate,
            endDate = p_endDate,
            travelerID = p_travelerID,
            locationID = p_locationID
        WHERE tripID = p_tripID;

        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching trip found for id: ', p_tripID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    COMMIT;
END //
DELIMITER ;


-- #############################
-- UPDATE segment
-- #############################
DROP PROCEDURE IF EXISTS sp_updateSegment;

DELIMITER //
CREATE PROCEDURE sp_updateSegment(
    IN p_segmentID INT,
    IN p_typeID INT,
    IN p_departureLocation VARCHAR(150),
    IN p_departureTime DATETIME,
    IN p_arrivalLocation VARCHAR(150),
    IN p_arrivalTime DATETIME,
    IN p_tripID INT
)
BEGIN
    DECLARE error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        UPDATE Segments
        SET typeID = p_typeID,
            departureLocation = p_departureLocation,
            departureTime = p_departureTime,
            arrivalLocation = p_arrivalLocation,
            arrivalTime = p_arrivalTime,
            tripID = p_tripID
        WHERE segmentID = p_segmentID;

        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching segment found for id: ', p_segmentID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    COMMIT;
END //
DELIMITER ;


-- #############################
-- UPDATE activity
-- #############################
DROP PROCEDURE IF EXISTS sp_updateActivity;

DELIMITER //
CREATE PROCEDURE sp_updateActivity(
    IN p_activityID INT,
    IN p_activityName VARCHAR(150),
    IN p_activityType VARCHAR(50),
    IN p_tripID INT
)
BEGIN
    DECLARE error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        UPDATE Activities
        SET activityName = p_activityName,
            activityType = p_activityType,
            tripID = p_tripID
        WHERE activityID = p_activityID;

        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching activity found for id: ', p_activityID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    COMMIT;
END //
DELIMITER ;


-- #############################
-- DELETE traveler
-- #############################
DROP PROCEDURE IF EXISTS sp_deleteTraveler;

DELIMITER //
CREATE PROCEDURE sp_deleteTraveler(IN p_travelerID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete from travelers
        DELETE FROM Travelers WHERE travelerID = p_travelerID;

        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching traveler found for id: ', p_travelerID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;


-- #############################
-- DELETE trip
-- #############################
DROP PROCEDURE IF EXISTS sp_deleteTrip;

DELIMITER //
CREATE PROCEDURE sp_deleteTrip(IN p_tripID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete from trips
        DELETE FROM Trips WHERE tripID = p_tripID;

        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching trip found for id: ', p_tripID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;


-- #############################
-- DELETE segment
-- #############################
DROP PROCEDURE IF EXISTS sp_deleteSegment;

DELIMITER //
CREATE PROCEDURE sp_deleteSegment(IN p_segmentID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete from segments
        DELETE FROM Segments WHERE segmentID = p_segmentID;

        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching segment found for id: ', p_segmentID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;


-- #############################
-- DELETE traveltype
-- #############################
DROP PROCEDURE IF EXISTS sp_deleteTravelType;

DELIMITER //
CREATE PROCEDURE sp_deleteTravelType(IN p_typeID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete from traveltypes
        DELETE FROM TravelTypes WHERE typeID = p_typeID;

        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching travel type found for id: ', p_typeID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;


-- #############################
-- DELETE location
-- #############################
DROP PROCEDURE IF EXISTS sp_deleteLocation;

DELIMITER //
CREATE PROCEDURE sp_deleteLocation(IN p_locationID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete from locations
        DELETE FROM Locations WHERE locationID = p_locationID;

        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching location found for id: ', p_locationID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;


-- #############################
-- DELETE activity
-- #############################
DROP PROCEDURE IF EXISTS sp_deleteActivity;

DELIMITER //
CREATE PROCEDURE sp_deleteActivity(IN p_activityID INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Delete from activity
        DELETE FROM Activities WHERE activityID = p_activityID;

        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching location found for id: ', p_activityID);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;