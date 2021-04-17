module.exports = function(app){
<<<<<<< HEAD
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
=======
    app.post('/testePost' ,function(req , res){
>>>>>>> 365ca17 (nodejs: Commit aplicado demonstra os estudo de node com utilizacao de Body-Parser.)

        // var connection = app.config.dbconnection();

<<<<<<< HEAD
        connection.query('select * from Persons;', function(error, result){
            res.send(result)
        })
        
>>>>>>> c8e4a3b (nodejs: Commit aplicado demonstra os estudo de node com correcao na funcionalidade para pegar dados.)
=======
        // connection.query('select * from Persons;', function(error, result){
        //     res.send(result)
        // })

        var requestBody = req.body;
        res.send(requestBody);
>>>>>>> 365ca17 (nodejs: Commit aplicado demonstra os estudo de node com utilizacao de Body-Parser.)
    })
}

