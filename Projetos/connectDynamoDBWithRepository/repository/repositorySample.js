const connectFac = require('../middleware/middlewareSample');
const path = require('path')
require('dotenv').config({ path: path.resolve(__dirname, '../.env') })

module.exports = function(app){
    const params = {
        TableName: process.env.TABLENAME
    };
    
    this.callExampleDynamo = async function() {
         console.log('Teste callExampleDynamo')
         return await connectFac.scan(params).promise();
    }

    this.callExample =  function() {
        return 'repositorio ok'
    }
    
    return this;
}