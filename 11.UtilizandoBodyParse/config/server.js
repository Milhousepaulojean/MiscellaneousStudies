var express = require('express');
var consign = require('consign');

var app = express()
 
consign()
    .include('routes')
    .then('config/dbconnection.js')
    .then('models/model.js')
    .into(app);

module.exports = app;