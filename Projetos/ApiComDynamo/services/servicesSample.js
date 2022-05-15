module.exports = function(app){
    this.callDynamoDBGetAll = async function(){
        return await app.repository.repositorySample.callDynamoDBGetAllItems();
    }

    this.callDynamoDBGetItem =  async function(){
        return await app.repository.repositorySample.callDynamoDBGetItems();
    }    

    return this;
}
