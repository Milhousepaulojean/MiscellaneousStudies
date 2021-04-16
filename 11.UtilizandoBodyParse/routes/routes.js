module.exports = function(app){
<<<<<<< HEAD
    app.post('/testePost' ,function(req , res){

        // var connection = app.config.dbconnection();

        // connection.query('select * from Persons;', function(error, result){
        //     res.send(result)
        // })

        var requestBody = req.body;
        res.send(requestBody);
=======
    app.get('/' ,function(req , res){

        var connection = app.config.dbconnection();

        connection.query('select * from Persons;', function(error, result){
            res.send(result)
        })
        
>>>>>>> c8e4a3b (nodejs: Commit aplicado demonstra os estudo de node com correcao na funcionalidade para pegar dados.)
    })
}

