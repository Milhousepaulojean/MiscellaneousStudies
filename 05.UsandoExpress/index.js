var express = require('express');
var app = express();

app.get('/' ,function(req , res){
    res.send('Localhost indentificado');
})

app.get('/testeurl' ,function(req , res){
    res.send('Teste de url indentificado');
})

app.listen(3000, function(){
    console.log('Servidor rodando com express.');
})