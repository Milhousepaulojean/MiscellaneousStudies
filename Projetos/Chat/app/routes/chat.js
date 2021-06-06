module.exports = function(application){
    application.get('/chat' , function(req , res){
        application.app.controllers.chatController.iniciaChat(application, req , res);
    })

    application.post('/chat' , function(req , res){
        application.app.controllers.chatController.iniciaChat(application, req , res);
    })

    application.put('/' , function(req , res){
        res.send('Olá mundo!')
    })

    application.delete('/' , function(req , res){
        res.send('Olá mundo!')
    })
}