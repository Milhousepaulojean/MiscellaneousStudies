module.exports = function(application){
    application.get('/' , function(req , res){
        ///res.render('index')
        application.app.controllers.indexController.home(application, req , res);
    })

    application.post('/' , function(req , res){
        res.send('Olá mundo, post!')
    })

    application.put('/' , function(req , res){
        res.send('Olá mundo, put!')
    })

    application.delete('/' , function(req , res){
        res.send('Olá mundo, delete!')
    })
}