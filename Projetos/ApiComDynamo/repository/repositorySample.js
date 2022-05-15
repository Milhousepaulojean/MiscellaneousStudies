const AWS = require('aws-sdk');
module.exports = function(app){
    this.callDynamoDBGetAllItems = async function(){
        const dynamodb = new AWS.DynamoDB({
            endpoint: "http://localhost:4566",
            region: "sa-east-1"
        });
        const params = {
            TableName: 'Music',
            ProjectionExpression: "Artist"
        };

        const retorno = await dynamodb.scan(params).promise();
        return retorno
    }

    this.callDynamoDBGetItems = async function(){
        const dynamodb = new AWS.DynamoDB({
            endpoint: "http://localhost:4566",
            region: "sa-east-1"
        });
            var params = {
            ExpressionAttributeValues: {
                ":v1": {S: 'No One You Know'}
            },
            KeyConditionExpression: "Artist = :v1",
            TableName: 'Music',
            };


        const retorno = await dynamodb.query(params).promise();
//          const retorno = ddbDocClient.send(new GetCommand(params));
        return retorno
    }

    return this;
}
