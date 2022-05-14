module.exports = async function(app){
    return await app.repository.repositorySample.callDynamoDBGetAllItems();
}
