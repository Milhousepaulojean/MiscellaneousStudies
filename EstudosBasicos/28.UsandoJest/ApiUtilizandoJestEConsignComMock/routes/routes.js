module.exports = function(app){
    // #swagger.parameters['id'] = { description: 'ID do usuário.' }
    app.get('/' ,function(req , res){
        const serviceExample = app.services.servicesSample.callServicesExample(); 
        console.log(`Console log real: ${serviceExample}`);
        res.status(200).send(serviceExample);
    })
}
