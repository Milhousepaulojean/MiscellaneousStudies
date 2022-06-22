module.exports = function(app){
    app.get('/urlexemplo' ,function(req , res){
        const serviceExample = app.services.servicesSample; 
        res.send(serviceExample)
    })
}
