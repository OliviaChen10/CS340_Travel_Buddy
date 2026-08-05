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
-- CREATE location
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
-- CREATE location
-- #############################
DROP PROCEDURE IF EXISTS sp_createTrip;

DELIMITER //
CREATE PROCEDURE sp_createTrip(
    IN p_startDate DATE,
    IN p_endDate DATE,
    IN p_travelerID INT,
    IN p_locationID INT,
    OUT p_tripID INT
)

BEGIN
    INSERT INTO Trips (startDate, endDate, travelerID, locationID)
    VALUES (p_startDate, p_endDate, p_travelerID, p_locationID);

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