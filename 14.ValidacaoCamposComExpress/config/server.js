var express = require('express');
var consign = require('consign');
var bodyParser = require('body-parser');


var app = express()


app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());


consign()
    .include('routes/')
    .then('config/dbconnection.js')
    .then('models/DataDAO.js')
    .into(app);

module.exports = app;