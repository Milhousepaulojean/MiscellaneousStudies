module.exports = function(app){
    // #swagger.parameters['id'] = { description: 'ID do usuário.' }
    app.post('/save' , async function(req , res){
        const serviceExample = await app.services.servicesSample.callServicesExample(); 
        res.send(serviceExample)
    })
}
