require('dotenv').config()
const AWS = require('aws-sdk');

module.exports = function () {
    AWS.config.update({
        endpoint: "http://localhost:8000",
        region: "us-west-2",
    });

    const docClient = new AWS.DynamoDB.DocumentClient();
    return docClient;
}    