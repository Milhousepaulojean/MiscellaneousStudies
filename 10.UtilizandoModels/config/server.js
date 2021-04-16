var express = require('express');
var app = express()
 
var consign = require('consign');

consign()
    .include('routes')
    .then('config/dbconnection.js')
<<<<<<< HEAD
    .then('models/model.js')
=======
    .then('../models/model.js')
>>>>>>> ada7cf1 (nodejs: Commit aplicado demonstra os estudo de node Utilizando Models com Consign .)
    .into(app);

module.exports = app;