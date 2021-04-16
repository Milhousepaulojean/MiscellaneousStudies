<<<<<<< HEAD
module.exports = function(application){
    application.get('/' ,function(req , res){

        var connection = application.config.dbconnection();
        var modelExemplo = application.models.model;

        modelExemplo.getData(connection, function(error, result){
=======
module.exports = function(app){
    app.get('/' ,function(req , res){

        var connection = app.config.dbconnection();

        connection.query('select * from Persons;', function(error, result){
>>>>>>> ada7cf1 (nodejs: Commit aplicado demonstra os estudo de node Utilizando Models com Consign .)
            res.send(result)
        })
        
    })
}

