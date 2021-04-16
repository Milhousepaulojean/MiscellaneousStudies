var express = require('express');
var app = express()
 
var consign = require('consign');

consign()
    .include('routes')
    .then('config/dbconnection.js')
    .into(app);

module.exports = app;