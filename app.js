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
// ########## ROUTE HANDLERS

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
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});