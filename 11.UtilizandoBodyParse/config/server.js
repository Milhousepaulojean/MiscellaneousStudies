var express = require('express');
var consign = require('consign');
<<<<<<< HEAD
<<<<<<< HEAD
var bodyParser = require('body-parser');

var app = express()
 
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }))
 
// parse application/json
app.use(bodyParser.json())

consign()
    .include('routes')
<<<<<<< HEAD
=======
=======
var bodyParser = require('body-parser');
>>>>>>> 365ca17 (nodejs: Commit aplicado demonstra os estudo de node com utilizacao de Body-Parser.)

var app = express()
 
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }))
 
// parse application/json
app.use(bodyParser.json())

consign()
    .include('routes')
    .then('config/dbconnection.js')
    .then('models/model.js')
>>>>>>> c8e4a3b (nodejs: Commit aplicado demonstra os estudo de node com correcao na funcionalidade para pegar dados.)
=======
>>>>>>> c1eb282 (nodejs: Commit aplicado demonstra os estudo com utilizacao de Inserts, refactores de chamadas)
    .into(app);

module.exports = app;