module.exports = function(app){
    app.get('/' , async function(req , res){
        const serviceExample = app.services.servicesSample;
        res.send({"message": serviceExample})
    });

    app.get('/chamadaDynamo' , function(req , res){
        const response =  app.services.servicesSample.callDynamo;
        res.send({"message": response})
    });
}

