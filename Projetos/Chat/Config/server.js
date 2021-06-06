/* Step 3. Importar modulos dos Frameworks; */
const express = require("express");
var consign = require("consign");
var bodyParser = require("body-parser");
const expressValidator = require('express-validator');

/* Step 4. iniciar o objeto express */
var app = express();

/* Step 5. Middlewares, Arquivos estatico e Manipuladores do  bodyParse */
app.set('view engine' , 'ejs');
app.set('views' , './app/views');
app.use(bodyParser.urlencoded({ extended: true }));
app.use(expressValidator());

app.use(express.static('./app/public'));

/* AutoLoder do Objeto map */
consign()
    .include('./app/routes')    
    .then('./app/models')
    .then('./app/controllers')
    .into(app);

/* Step 6. Exportar o objeto app */
module.exports = app;