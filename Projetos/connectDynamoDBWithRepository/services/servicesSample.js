



module.exports = function(app){
    //return await app.repository.repositorySample.callExampleDynamo();
    return app.repository.repositorySample.callExample();
}

module.exports.callDynamo = function(app){
    console.log('Teste callDynamo')
    return 'this callDynamo'
    //return await app.repository.repositorySample.callExampleDynamo();
    //return await app.repository.repositorySample.callExampleDynamo();
}
