var mysql = require('mysql');

var conn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'case_study01'
})

conn.query('select * from Persons;', function(error, result){
    console.log(result)
})
