var express = require('express');
var mensagem = require('./examplocommom')()
var app = express();

app.get('/' ,function(req , res){
    res.send(mensagem);
})

app.listen(3000, function(){
    console.log('Servidor rodando com express.');
})