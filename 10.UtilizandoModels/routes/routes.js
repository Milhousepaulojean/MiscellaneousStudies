<<<<<<< HEAD
<<<<<<< HEAD
module.exports = function(application){
    application.get('/' ,function(req , res){

        var connection = application.config.dbconnection();
        var modelExemplo = application.models.model;

        modelExemplo.getData(connection, function(error, result){
=======
module.exports = function(app){
    app.get('/' ,function(req , res){
=======
module.exports = function(application){
    application.get('/' ,function(req , res){
>>>>>>> c1eb282 (nodejs: Commit aplicado demonstra os estudo com utilizacao de Inserts, refactores de chamadas)

        var connection = application.config.dbconnection();
        var modelExemplo = application.models.model;

<<<<<<< HEAD
        connection.query('select * from Persons;', function(error, result){
>>>>>>> ada7cf1 (nodejs: Commit aplicado demonstra os estudo de node Utilizando Models com Consign .)
=======
        modelExemplo.getData(connection, function(error, result){
>>>>>>> c1eb282 (nodejs: Commit aplicado demonstra os estudo com utilizacao de Inserts, refactores de chamadas)
            res.send(result)
        })
        
    })
}

