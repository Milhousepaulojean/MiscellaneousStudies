require('dotenv').config({ path: '../.env' })
const AWS = require('aws-sdk');

module.exports = function(){
    AWS.config.update({
      endpoint: `${process.env.PROTOCOL}://${process.env.DOMAIN}:${process.env.PORT}`,
      accessKeyId: `${process.env.ACCESSKEYID}`,
      secretAccessKey: `${process.env.SECRETACCESSKEY}`,
      region: `${process.env.REGION}`,
    });
    const docClient = new AWS.DynamoDB.DocumentClient();
    return docClient;
}