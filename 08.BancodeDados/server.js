var conn = require("./config")();

conn.query('select * from Persons;', function(error, result){
    console.log(result)
})
