module.exports = function(app){
    app.get('/' ,function(req , res){

        var connection = app.config.dbconnection();

        connection.query('select * from Persons;', function(error, result){
            res.send(result)
        })
        
    })
}

