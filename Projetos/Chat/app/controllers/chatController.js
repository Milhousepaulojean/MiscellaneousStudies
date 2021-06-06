module.exports.iniciaChat = function(application, req, res){
    var dadosForm = req.body;

    req.check("apelido" ,'Nome ou Apelido é Obrigatorio').notEmpty();
    //req.assert("apelido" ,'Nome deve ser mais extenso;').len(3,15);

    var erros = req.validationErrors();

    if(erros){
        res.send('Por favor verifique os erros');
        return;
    }

    res.render('chat');
}