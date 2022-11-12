module.exports = function(app){
    // #swagger.parameters['id'] = { description: 'ID do usuário.' }
    app.get('/' ,function(req , res){
        const serviceExample = app.services.servicesSample; 
        res.send(serviceExample)
    })
}
