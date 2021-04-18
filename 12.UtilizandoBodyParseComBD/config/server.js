var express = require('express');
var consign = require('consign');
var bodyParser = require('body-parser');

var app = express()
 
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }))
 
// parse application/json
app.use(bodyParser.json())

consign()
    .include('routes')
    .then('config/dbconnection.js')
    .then('models/model.js')
    .into(app);

module.exports = app;