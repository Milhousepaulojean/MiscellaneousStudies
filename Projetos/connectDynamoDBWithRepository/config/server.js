require('dotenv').config({ path: '../.env' })
const swaggerUi = require('swagger-ui-express');
const swaggerFile = require('../swagger-output.json');
const bodyParser = require('body-parser');
var express = require('express');
var app = express()

var consign = require('consign');

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json())
app.use('/doc', swaggerUi.serve, swaggerUi.setup(swaggerFile))

consign()
    .include('routes')
    .then('repository')
    .then('services')
    .into(app);

module.exports = app;