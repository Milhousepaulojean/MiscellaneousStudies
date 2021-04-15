var http = require('http')

http.createServer(function(req, res){
    if(req.url == '/testederotas'){
        res.end("Teste de rotas com sucesso")
    }else{
        res.end("Url nao identificada")
    }

console.log('Servidor ativo com sucesso.')

}).listen(3000)