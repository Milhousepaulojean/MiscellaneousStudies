var express = require('express'),
    bodyParse = require('body-parser'),
    mongoDB = require('mongodb');

var app = express();

app.use(bodyParse.urlencoded({extended:true}))
app.use(bodyParse.json());

var port = 8080

app.listen(port);

console.log('Servidor Online na porta :' + port)


app.get('/' , function(req, res){
    res.send('hello World')
})


app.post('/api' , function(req, res){
    
    var rq = req.body;

    res.send(rq)

    //TODO: INSTALL MONGO EQUALS FOLDER 17.NoSQL
})