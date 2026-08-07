// ########################################
// ############ Citations ############

/*
    Citation for creating webapp 
    Date Accessed: 07/28/2026
    Based on the directions/code from Oregon State CS340 Exploration - Web Application Technology.
    Created UI pages using node.js instructions and started app.js based on instrcutions. 
    Source URL: https://canvas.oregonstate.edu/courses/2051721/pages/exploration-web-application-technology-2?module_item_id=26923351
*/

/*
    Citation for implementing CRUD operations
    Date Accessed: 08/04/2026
    Based on the directions/code from Oregon State CS340 Exploration - Implementing CUD operations in your app.
    Wrote stored procedures and route handler code using node.js instructions.
    Source URL: https://canvas.oregonstate.edu/courses/2051721/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26923368
*/


// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 27072;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ############ ROUTE HANDLERS ############

// READ ROUTES

app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/travelers', async function (req, res) {
    try {
        const [travelers] = await db.query(`
            SELECT travelerID AS ID, username AS Name, email AS Email
            FROM Travelers;
        `);
        res.render('travelers', { travelers: travelers });
    } catch (error) {
        console.error('Error rendering travelers page:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/locations', async function (req, res) {
    try {
        const [locations] = await db.query(`
            SELECT locationID AS ID, countryName AS Country, continent AS Continent
            FROM Locations
        `);
        res.render('locations', { locations: locations, error: req.query.error });
    } catch (error) {
        console.error('Error rendering locations page:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/trips', async function (req, res) {
    try {
        const [trips] = await db.query(`
            SELECT Trips.tripID AS ID, Trips.tripName as Name, Trips.startDate AS Start, 
            Trips.endDate AS End, Travelers.username AS Traveler, Locations.countryName as Location
            FROM Trips
            JOIN Travelers ON Trips.travelerID = Travelers.travelerID
            JOIN Locations ON Trips.locationID = Locations.locationID;
        `);
        const [travelers] = await db.query(`SELECT * FROM Travelers;`);
        const [locations] = await db.query(`SELECT * FROM Locations;`);
        res.render('trips', { trips: trips, travelers: travelers, locations: locations });
    } catch (error) {
        console.error('Error rendering trips page:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/segments', async function (req, res) {
    try {
        const [segments] = await db.query(`
            SELECT Segments.segmentID AS ID, TravelTypes.travelName as Via, 
                Segments.departureLocation AS Departure, 
                Segments.departureTime as DepartureTime, 
                Segments.arrivalLocation as Arrival, 
                Segments.arrivalTime as ArrivalTime, 
                Trips.tripName as Trip
            FROM Segments
            JOIN TravelTypes ON Segments.typeID = TravelTypes.typeID
            JOIN Trips ON Segments.tripID = Trips.tripID;
            `);
        const [trips] = await db.query('SELECT * FROM Trips;');
        const [travelTypes] = await db.query('SELECT * FROM TravelTypes;');
        res.render('segments', { segments: segments, trips: trips, travelTypes: travelTypes });
    } catch (error) {
        console.error('Error rendering segments page:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/activities', async function (req, res) {
    try {
        const [activities] = await db.query(`
            SELECT Activities.activityID AS ID, Activities.activityName as Activity, 
            Activities.activityType as Type, Trips.tripName as Trip
            FROM Activities
            JOIN Trips ON Activities.tripID = Trips.tripID;
        `);
        const [trips] = await db.query('SELECT * FROM Trips;');
        res.render('activities', { activities: activities, trips: trips });
    } catch (error) {
        console.error('Error rendering activities page:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/traveltypes', async function (req, res) {
    try {
        const [travelTypes] = await db.query(`
            SELECT typeID AS ID, travelName AS Name
            FROM TravelTypes
        `);
        res.render('traveltypes', { travelTypes: travelTypes, error: req.query.error });
    } catch (error) {
        console.error('Error rendering traveltypes page:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});


// ########################################
// ################ CREATE ################

app.post('/travelers/create', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_createTraveler(?, ?, @newID);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.username,
            data.email,
        ]);
        console.log(`CREATE travelers. ID: ${rows.newID}` +
            ` Username: ${data.username} Email: ${data.email}`
        );

        // Refresh page with updated webpage
        res.redirect('/travelers');
    } catch (error) {
        console.error('Cannot create new user:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

app.post('/trips/create', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_createTrip(?, ?, ?, ?, ?, @newID);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.tripName,
            data.startDate,
            data.endDate,
            data.travelerID,
            data.locationID,
        ]);
        console.log(`CREATE trip. ID: ${rows.newID}` +
            ` Trip Name: ${data.tripName} Start Date: ${data.startDate} End Date: ${data.endDate} 
            Traveler ID: ${data.travelerID} Location ID: ${data.locationID}`
        );

        // Refresh page with updated webpage
        res.redirect('/trips');
    } catch (error) {
        console.error('Cannot create new trip:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

app.post('/segments/create', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_createSegment(?, ?, ?, ?, ?, ?, @newID);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.typeID,
            data.departureLocation,
            data.departureTime,
            data.arrivalLocation,
            data.arrivalTime,
            data.tripID,
        ]);
        console.log(`CREATE segment. ID: ${rows.newID}` +
            ` Type ID: ${data.typeID} Departure Location: ${data.departureLocation} 
            Departure Time: ${data.departureTime} Arrival Location: ${data.arrivalLocation} 
            Arrival Time: ${data.arrivalTime} Trip ID: ${data.tripID}`
        );

        // Refresh page with updated webpage
        res.redirect('/segments');
    } catch (error) {
        console.error('Cannot create new segment:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

app.post('/traveltypes/create', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_createTravelType(?, @newID);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.travelName,
        ]);
        console.log(`CREATE travelType. ID: ${rows.newID}` +
            ` Name: ${data.travelName}`
        );

        // Refresh page with updated webpage
        res.redirect('/traveltypes');
    } catch (error) {
        console.error('Cannot create new travel type:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

app.post('/locations/create', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_createLocation(?, ?, @newID);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.countryName,
            data.continent,
        ]);
        console.log(`CREATE location. ID: ${rows.newID}` +
            ` Name: ${data.countryName} Continent: ${data.continent}`
        );

        // Refresh page with updated webpage
        res.redirect('/locations');
    } catch (error) {
        console.error('Cannot create new locations:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

app.post('/activities/create', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_createActivity(?, ?, ?, @newID);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.activityName,
            data.activityType,
            data.tripID,
        ]);
        console.log(`CREATE activity. ID: ${rows.newID}` +
            ` Name: ${data.activityName} - ${data.activityType}`
        );

        // Refresh page with updated webpage
        res.redirect('/activities');
    } catch (error) {
        console.error('Cannot create new activity:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

// ########################################
// ############### UPDATE #################

app.post('/travelers/update', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_updateTraveler(?, ?, ?);`;
        await db.query(query1, [data.travelerID, data.username, data.email]);

        console.log(`UPDATE traveler. ID: ${data.travelerID} Username: ${data.username} Email: ${data.email}`);
        res.redirect('/travelers');
    } catch (error) {
        console.error('Cannot update traveler:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

app.post('/locations/update', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_updateLocation(?, ?, ?);`;
        await db.query(query1, [data.locationID, data.countryName, data.continent]);

        console.log(`UPDATE location. ID: ${data.locationID} Country: ${data.countryName} Continent: ${data.continent}`);
        res.redirect('/locations');
    } catch (error) {
        console.error('Cannot update location:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

app.post('/traveltypes/update', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_updateTravelType(?, ?);`;
        await db.query(query1, [data.typeID, data.travelName]);

        console.log(`UPDATE travelType. ID: ${data.typeID} Name: ${data.travelName}`);
        res.redirect('/traveltypes');
    } catch (error) {
        console.error('Cannot update travel type:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

app.post('/trips/update', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_updateTrip(?, ?, ?, ?, ?, ?);`;
        await db.query(query1, [
            data.tripID,
            data.tripName,
            data.startDate,
            data.endDate,
            data.travelerID,
            data.locationID,
        ]);

        console.log(`UPDATE trip. ID: ${data.tripID} Name: ${data.tripName}`);
        res.redirect('/trips');
    } catch (error) {
        console.error('Cannot update trip:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

app.post('/segments/update', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_updateSegment(?, ?, ?, ?, ?, ?, ?);`;
        await db.query(query1, [
            data.segmentID,
            data.typeID,
            data.departureLocation,
            data.departureTime,
            data.arrivalLocation,
            data.arrivalTime,
            data.tripID,
        ]);

        console.log(`UPDATE segment. ID: ${data.segmentID}`);
        res.redirect('/segments');
    } catch (error) {
        console.error('Cannot update segment:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});

app.post('/activities/update', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_updateActivity(?, ?, ?, ?);`;
        await db.query(query1, [
            data.activityID,
            data.activityName,
            data.activityType,
            data.tripID,
        ]);

        console.log(`UPDATE activity. ID: ${data.activityID} Name: ${data.activityName}`);
        res.redirect('/activities');
    } catch (error) {
        console.error('Cannot update activity:', error);
        res.status(500).send('An error occured while executing the database queries.');
    }
});


// ########################################
// ############### DELETE #################

app.post('/travelers/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        const query1 = `CALL sp_deleteTraveler(?);`;
        await db.query(query1, [data.travelerID]);

        console.log(`DELETE traveler. ID: ${data.travelerID}` +
            ` Name: ${data.username} Email: ${data.email}`
        );

        // Redirect user to updated page
        res.redirect('/travelers');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occured while executing the database queries.')
    }
})

app.post('/trips/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        const query1 = `CALL sp_deleteTrip(?);`;
        await db.query(query1, [data.tripID]);

        console.log(`DELETE trip. ID: ${data.tripID}` +
            ` Trip: ${data.tripName}`
        );

        // Redirect user to updated page
        res.redirect('/trips');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occured while executing the database queries.')
    }
})

app.post('/segments/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        const query1 = `CALL sp_deleteSegment(?);`;
        await db.query(query1, [data.segmentID]);

        console.log(`DELETE trip. ID: ${data.segmentID}` +
            ` Departure: ${data.segmentID} ${data.departureLocation} Arrival: ${data.arrivalLocation}`
        );

        // Redirect user to updated page
        res.redirect('/segments');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occured while executing the database queries.')
    }
})

app.post('/traveltypes/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        const query1 = `CALL sp_deleteTravelType(?);`;
        await db.query(query1, [data.typeID]);

        console.log(`DELETE traveltype. ID: ${data.typeID}` +
            ` Name: ${data.travelName}`
        );

        // Redirect user to updated page
        res.redirect('/traveltypes');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.redirect('/traveltypes?error=' + encodeURIComponent('This travel type cannot be deleted because it is used by one or more segments.'));
    }
})

app.post('/locations/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        const query1 = `CALL sp_deleteLocation(?);`;
        await db.query(query1, [data.locationID]);

        console.log(`DELETE traveler. ID: ${data.locationID}` +
            ` Country: ${data.countryName} Continent: ${data.continent}`
        );

        // Redirect user to updated page
        res.redirect('/locations');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.redirect('/locations?error=' + encodeURIComponent('This location cannot be deleted because it is used by one or more trips.'));
    }
})

app.post('/activities/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        const query1 = `CALL sp_deleteActivity(?);`;
        await db.query(query1, [data.activityID]);

        console.log(`DELETE traveler. ID: ${data.activityID}` +
            ` Name: ${data.activityName} - ${data.activityType}`
        );

        // Redirect user to updated page
        res.redirect('/activities');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occured while executing the database queries.')
    }
})

// ########################################
// ############## RESET ################

app.post('/reset', async function (req, res) {
    try {
        await db.query('CALL sp_resetDatabase();');
        console.log('DATABASE RESET: all tables dropped, recreated, and reseeded.');
        res.redirect('/');
    } catch (error) {
        console.error('Error resetting database:', error);
        res.status(500).send('An error occurred while resetting the database.');
    }
});


// ########################################
// ############## LISTENER ################

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});