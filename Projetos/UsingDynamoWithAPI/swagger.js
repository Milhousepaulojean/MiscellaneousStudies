const swaggerAutogen = require('swagger-autogen')();

const doc = {
  info: {
    version: '',      // by default: '1.0.0'
    title: '',        // by default: 'REST API'
    description: '',  // by default: ''
  },
  host: 'localhost:3000',      // by default: 'localhost:3000'
  basePath: '/',  // by default: '/'
  schemes: ['http'],   // by default: ['http']
  consumes: ['application/json'],  // by default: ['application/json']
  produces: ['application/json'],  // by default: ['application/json']
  tags: [        // by default: empty Array
    {
      name: '',         // Tag name
      description: '',  // Tag description
    },
    // { ... }
  ],
  securityDefinitions: {},  // by default: empty object
  definitions: {
    inseriritem: {
      organizacao: '58DD61E9-993D-4AA4-8AFB-78B5B55CDA79',
      unidade_organizacional: '6FC300C4-1207-49A6-AE49-D584133C8624',
      chatbot: '8F8C717A-BFFC-4BFA-8E04-605361410172',
      cod_clie: '32679660862',
      cod_mens: '7D353B04-AC34-46A0-80E8-C1CBA1A15BC3',
      tip_rem: 'agent',
      nome_rem: 'Fulano de tal 2',
      origem: 'iumessenger'
    },
  },          // by default: empty object (Swagger 2.0)
  components: {}            // by default: empty object (OpenAPI 3.x)
};

const outputFile = './swagger-output.json';
const endpointsFiles = ['./routes/routes.js',];

/* NOTE: if you use the express Router, you must pass in the 
   'endpointsFiles' only the root file where the route starts,
   such as index.js, app.js, routes.js, ... */

swaggerAutogen(outputFile, endpointsFiles, doc).then(() => {
  require('./index.js'); // Your project's root file
});


/*
Fontes: https://www.npmjs.com/package/swagger-autogen 
        https://davibaltar.medium.com/documenta%C3%A7%C3%A3o-autom%C3%A1tica-de-apis-em-node-js-eb03041c643b
*/
