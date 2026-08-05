// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 27071;

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
        const [travelers] = await db.query('SELECT * FROM Travelers;');
        res.render('travelers', { travelers: travelers });
    } catch (error) {
        console.error('Error rendering travelers page:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/locations', async function (req, res) {
    try {
        const [locations] = await db.query('SELECT * FROM Locations;');
        res.render('locations', { locations: locations });
    } catch (error) {
        console.error('Error rendering locations page:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/trips', async function (req, res) {
    try {
        const [trips] = await db.query('SELECT * FROM Trips;');
        const [travelers] = await db.query('SELECT * FROM Travelers;');
        const [locations] = await db.query('SELECT * FROM Locations;');
        res.render('trips', { trips: trips, travelers: travelers, locations: locations });
    } catch (error) {
        console.error('Error rendering trips page:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/segments', async function (req, res) {
    try {
        const [segments] = await db.query('SELECT * FROM Segments;');
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
        const [activities] = await db.query('SELECT * FROM Activities;');
        const [trips] = await db.query('SELECT * FROM Trips;');
        res.render('activities', { activities: activities, trips: trips });
    } catch (error) {
        console.error('Error rendering activities page:', error);
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/traveltypes', async function (req, res) {
    try {
        const [travelTypes] = await db.query('SELECT * FROM TravelTypes;');
        res.render('traveltypes', { travelTypes: travelTypes });
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
            `Name: ${data.username} ${data.email}`
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
        const query1 = `CALL sp_createTrip(?, ?, ?, ?, @newID);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.startDate,
            data.endDate,
            data.travelerID,
            data.locationID,
        ]);
        console.log(`CREATE trip. ID: ${rows.newID}` +
            `Name: ${data.startDate} ${data.endDate} ${data.travelerID} ${data.locationID}`
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
            `Name: ${data.typeID} ${data.departureLocation} ${data.departureTime} 
            ${data.arrivalLocation} ${data.arrivalTime} ${data.tripID}`
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
            `Name: ${data.travelName}`
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
            `Name: ${data.countryName} ${data.continent}`
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
            `Name: ${data.activityName} ${data.activityType} ${data.tripID}`
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



// ########################################
// ############### DELETE #################

app.post('/travelers/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        const query1 = `CALL sp_deleteTraveler(?);`;
        await db.query(query1, [data.travelerID]);

        console.log(`DELETE traveler. ID: ${data.travelerID}` +
            `Name: ${data.travelerID}`
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
            `Name: ${data.tripID}`
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
            `Name: ${data.segmentID}`
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
            `Name: ${data.typeID}`
        );

        // Redirect user to updated page
        res.redirect('/traveltypes');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occured while executing the database queries.')
    }
})

app.post('/locations/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        const query1 = `CALL sp_deleteLocation(?);`;
        await db.query(query1, [data.locationID]);

        console.log(`DELETE traveler. ID: ${data.locationID}` +
            `Name: ${data.locationID}`
        );

        // Redirect user to updated page
        res.redirect('/locations');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occured while executing the database queries.')
    }
})

app.post('/activities/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        const query1 = `CALL sp_deleteActivity(?);`;
        await db.query(query1, [data.activityID]);

        console.log(`DELETE traveler. ID: ${data.activityID}` +
            `Name: ${data.activityID}`
        );

        // Redirect user to updated page
        res.redirect('/activities');
    } catch (error) {
        console.error('Error executing queries:', error);
        res.status(500).send('An error occured while executing the database queries.')
    }
})

// ########################################
// ############## LISTENER ################

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});