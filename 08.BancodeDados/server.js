<<<<<<< HEAD
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
=======
var conn = require("./config")();
>>>>>>> 8b5075e (nodejs: Commit aplicado demonstra os estudo de node com BD e utilizando Consign .)

conn.query('select * from Persons;', function(error, result){
    console.log(result)
})
