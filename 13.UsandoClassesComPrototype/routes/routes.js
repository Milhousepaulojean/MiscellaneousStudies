module.exports = function(application){
    application.post('/testePost' ,function(req , res){
        var connection = application.config.dbconnection();
        var modelExemplo = new application.models.DataDAO(connection);

        modelExemplo.saveData(req.body, function(error, result){
            res.send(result)
        })
    })
}

