var http = require('http')

http.createServer(function (req, res) {
    if (req.url == '/testederotas') {
        res.end("Teste de rotas com sucesso");
    } else {
        res.end("Url nao identificada");
    }
}).listen(3000);

console.log('Servidor ativo com sucesso.');