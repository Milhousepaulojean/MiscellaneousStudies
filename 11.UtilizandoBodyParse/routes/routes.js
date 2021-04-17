module.exports = function(app){
    app.post('/testePost' ,function(req , res){

        // var connection = app.config.dbconnection();

        // connection.query('select * from Persons;', function(error, result){
        //     res.send(result)
        // })

        var requestBody = req.body;
        res.send(requestBody);
    })
}

