require('dotenv').config({ path: '../.env' })
const AWS = require('aws-sdk');

module.exports = function(){
    
    return new AWS.DynamoDB.DocumentClient({
      endpoint: `http://localhost:4566`,
      region: `sa-east-1`,
    });
    
}