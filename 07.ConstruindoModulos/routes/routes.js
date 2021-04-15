var app = require('../config/server')

module.exports = function(app){
    app.get('/' ,function(req , res){
        res.send('Teste com sucesso');
    })
}

