module.exports = function(application){
    application.get('/' ,function(req , res){

        var connection = application.config.dbconnection();
        var modelExample = application.app.models.model();

        modelExample.getData(connection, function(error, result){
            res.send(result)
        });
        
    })
}

