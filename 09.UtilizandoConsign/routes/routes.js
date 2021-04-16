<<<<<<< HEAD
module.exports = function(application){
    application.get('/' ,function(req , res){

        var connection = application.config.dbconnection();
        var modelExample = application.app.models.model();

        modelExample.getData(connection, function(error, result){
            res.send(result)
        });
=======
//var app = require('../config/server')

module.exports = function(app){
    app.get('/' ,function(req , res){

        var connection = app.config.dbconnection();

        connection.query('select * from Persons;', function(error, result){
            res.send(result)
        })
>>>>>>> 8b5075e (nodejs: Commit aplicado demonstra os estudo de node com BD e utilizando Consign .)
        
    })
}

