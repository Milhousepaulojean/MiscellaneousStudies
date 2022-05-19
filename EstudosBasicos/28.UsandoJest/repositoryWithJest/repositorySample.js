const AWS = require('aws-sdk');

exports.callDynamoDBGetItems = async function() {

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
        console.log(`Resposta via testeUnitario ${JSON.stringify(retorno)}`)
        return retorno
}