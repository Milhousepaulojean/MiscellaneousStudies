const swaggerAutogen = require('swagger-autogen')()

const outputFile = './swagger_output.json'
const endpointsFiles = ['./endpoints.js']

// Para geracao do arquivo : swagger_output.json
// swaggerAutogen(outputFile, endpointsFiles)

swaggerAutogen(outputFile, endpointsFiles).then(() => {
    require('./index.js')
})