module.exports = function(app){
    this.callDynamoDBGetItems = async function(){
        
        const dynamodb = app.middleware.ConnectFactory;
        
        var params = {
            ExpressionAttributeValues: {
                ":v1": {S: 'No One You Know'}
            },
            KeyConditionExpression: "Artist = :v1",
            TableName: 'Music' //process.env.TABLENAME,
            };


        const retorno = await dynamodb.query(params).promise();

            console.log(`retorno da query ${JSON.stringify(retorno)}`)
//          const retorno = ddbDocClient.send(new GetCommand(params));
        return retorno
    }

    return this
}
