const AWS = require('aws-sdk');
module.exports = function(app){
    this.callDynamoDBGetAllItems = async function(){
        const dynamodb = new AWS.DynamoDB({
            endpoint: "http://localhost:4566",
            region: "sa-east-1"
        });
        const params = {
            TableName: 'Music'
        };

        const retorno = await dynamodb.scan(params).promise();
        return retorno
    }

    return this;
}
