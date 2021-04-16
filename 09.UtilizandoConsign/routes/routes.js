<<<<<<< HEAD
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
=======
module.exports = function(application){
    application.get('/' ,function(req , res){
>>>>>>> ac34bb9 (nodejs: Commit aplicado demonstra os estudo de node com exclusao de Required .)

        var connection = application.config.dbconnection();
        var modelExample = application.app.models.model();

        modelExample.getData(connection, function(error, result){
            res.send(result)
<<<<<<< HEAD
        })
>>>>>>> 8b5075e (nodejs: Commit aplicado demonstra os estudo de node com BD e utilizando Consign .)
=======
        });
>>>>>>> ac34bb9 (nodejs: Commit aplicado demonstra os estudo de node com exclusao de Required .)
        
    })
}

