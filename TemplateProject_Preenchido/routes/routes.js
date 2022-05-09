module.exports = function(app){
    app.get('/' ,function(req , res){
        const serviceExample = app.services.servicesSample;

        res.send({"message": serviceExample})
    })
}

