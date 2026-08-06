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