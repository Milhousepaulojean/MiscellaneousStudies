<<<<<<< HEAD
var conn = require("./config")();
=======
var mysql = require('mysql');

var conn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'case_study01'
})
>>>>>>> b1c55f5 (nodejs: Commit aplicado para estudo de conexao .)

conn.query('select * from Persons;', function(error, result){
    console.log(result)
})
