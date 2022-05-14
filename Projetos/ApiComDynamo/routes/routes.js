module.exports = function(app){
    app.get('/rotaTest' , async function(req , res){
        const serviceExample = await app.services.servicesSample; 
        res.send(JSON.stringify(serviceExample))
    })
}
