var app = require('./config/server')
var routes = require('./routes/routes')

//rotas
routes(app)

app.listen(3000, function(){
    console.log('Servidor rodando com express.');
})