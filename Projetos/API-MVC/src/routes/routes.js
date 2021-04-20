module.exports = function(application){
    application.get('/' ,function(req , res){
        application.controllers.MainControllers.main(application , req, res);
    })
}