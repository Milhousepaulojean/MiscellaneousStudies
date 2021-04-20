module.exports = function(application){
    application.post('/testePost' ,function(req , res){
        var requestBody = req.body;
        var connection = application.config.dbconnection();
        var modelExemplo = application.models.model;

        modelExemplo.saveData(requestBody, connection, function(error, result){
            res.send(result)
        })

        res.send(requestBody);
    })
}

