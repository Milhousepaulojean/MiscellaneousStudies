const AWS = require('aws-sdk');
const config = require('./config');

module.exports = function(){
    AWS.config.update(config.aws_local_config);
    const docClient = new AWS.DynamoDB.DocumentClient();
    return docClient;
}