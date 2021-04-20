module.exports = function(application){
	application.post('/testePost',
    function(req , res){
        application.controllers.controllerTest.controllerPrincipal(application , req, res);
		})
}
