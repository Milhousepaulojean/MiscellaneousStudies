var express = require('express');
var application = express();

var consign = require('consign');


consign()
    .include('routes')
    .then('controllers/')
    .into(application);

module.exports = application;