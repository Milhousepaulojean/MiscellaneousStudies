#!/bin/sh

#Install NPM INT
npm init -y

#Install express
npm i express --save

#Install cors
npm i cors --save

#Install body-parser
npm i body-parser --save

#Install Nodemon
npm i --save-dev nodemon

#Install Consign
npm i consign --save

#Install swagger
npm i --save-dev swagger-autogen
npm i --save-dev swagger-ui-express

# Create Folders and Files
mkdir config
touch config/server.js
echo "const swaggerUi = require('swagger-ui-express');
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

module.exports = app;" > config/server.js


mkdir routes
touch routes/routes.js
echo "module.exports = function(app){
    // #swagger.parameters['id'] = { description: 'ID do usuário.' }
    app.get('/' ,function(req , res){
        const serviceExample = app.services.servicesSample; 
        res.send(serviceExample)
    })
}" > routes/routes.js

mkdir services
touch services/servicesSample.js
echo "module.exports = function(app){
    return app.repository.repositorySample;
}" > services/servicesSample.js

mkdir repository
touch repository/repositorySample.js
echo "module.exports = function(app){
    return 'repositorio ok'
}" > repository/repositorySample.js
 

touch Task.todo
touch index.js
echo "var app = require('./config/server')

app.listen(3000, function(){
    console.log('Servidor rodando com express.');
})" > index.js

touch swagger.js
echo "const swaggerAutogen = require('swagger-autogen')();

const doc = {
  info: {
    version: '',      // by default: '1.0.0'
    title: '',        // by default: 'REST API'
    description: '',  // by default: ''
  },
  host: '',      // by default: 'localhost:3000'
  basePath: '',  // by default: '/'
  schemes: [],   // by default: ['http']
  consumes: [],  // by default: ['application/json']
  produces: [],  // by default: ['application/json']
  tags: [        // by default: empty Array
    {
      name: '',         // Tag name
      description: '',  // Tag description
    },
    // { ... }
  ],
  securityDefinitions: {},  // by default: empty object
  definitions: {},          // by default: empty object (Swagger 2.0)
  components: {}            // by default: empty object (OpenAPI 3.x)
};

const outputFile = './swagger-output.json';
const endpointsFiles = ['./routes/routes.js', ];

/* NOTE: if you use the express Router, you must pass in the 
   'endpointsFiles' only the root file where the route starts,
   such as index.js, app.js, routes.js, ... */

swaggerAutogen(outputFile, endpointsFiles, doc).then(() => {
  require('./index.js'); // Your project's root file
});


/*
Fontes: https://www.npmjs.com/package/swagger-autogen 
        https://davibaltar.medium.com/documenta%C3%A7%C3%A3o-autom%C3%A1tica-de-apis-em-node-js-eb03041c643b
*/" > swagger.js

touch docker-compose.yml
echo "version: '3.0'

services:

  localstack:
    image: localstack/localstack:latest
    environment: 
      - AWS_DEFAULT_REGION=ap-southeast-1
      - EDGE_PORT=4566
      - SERVICES=dynamodb
      - KINESIS_PROVIDER=kinesalite
      - AWS_ACCESS_KEY_ID=dummyaccess
      - AWS_SECRET_ACCESS_KEY=dummysecret
      - AWS_DEFAULT_REGION=us-east-1
    ports:
      - '4566:4566'
    volumes:
      - '${TMPDIR:-/tmp/localstack}:/tmp/localstack'
      - '/var/run/docker.sock:/var/run/docker.sock'" > docker-compose.yml

#Swagger
node ./swagger.js

#Start Project
#nodemon