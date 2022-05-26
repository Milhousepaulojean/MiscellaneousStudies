module.exports = function(app){
    
    this.callServicesExample = async () =>{
        return await app.repository.repositorySample.callDynamoDBGetItems();
    }

    return this;

}
