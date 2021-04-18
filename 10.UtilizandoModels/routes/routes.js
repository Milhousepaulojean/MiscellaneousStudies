module.exports = function(application){
    application.get('/' ,function(req , res){

        var connection = application.config.dbconnection();
        var modelExemplo = application.models.model;

        modelExemplo.getData(connection, function(error, result){
            res.send(result)
        })
        
    })
}