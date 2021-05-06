var express = require('express')
// Import routes
var apiRoutes = require("./api-routes")
// Initialize the app
var app = express();
// Setup server port
var port = process.env.PORT || 8080;
// Import Body parser
var bodyParser = require('body-parser');
// Import Mongoose
var mongoose = require('mongoose');

const enviroment = require('dotenv').config({path: __dirname + '/.env'})

// Use Api routes in the App
app.use('/api', apiRoutes)

// Configure bodyparser to handle post requests
app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(bodyParser.json());

mongoose.connect(process.env['urlMongo'], { useNewUrlParser: true});

var db = mongoose.connection;

// Added check for DB connection
if(!db)
    console.log("Error connecting db")
else
    console.log("Db connected successfully")

// Send message for default URL
app.get('/', (req, res) => res.send('Hello World with Express'));
// Launch app to listen to specified port
app.listen(port, function () {
    console.log("Running RestHub on port " + port);
});

//https://medium.com/@dinyangetoh/how-to-build-simple-restful-api-with-nodejs-expressjs-and-mongodb-99348012925d