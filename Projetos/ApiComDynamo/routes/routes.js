module.exports = function(app){
    app.get('/rotacomscan' , async (req , res) =>{
        const serviceExample = await app.services.servicesSample.callDynamoDBGetAll(); 
        res.send(JSON.stringify(serviceExample))
    })

    app.get('/rotacomquery' , async (req, res) => {
        // #swagger.tags = ['User']
        // #swagger.description = 'Endpoint para obter um usuário.'
        /* #swagger.parameters['filtro'] = {
	       in: 'query',
               description: 'Um filtro qualquer.',
               type: 'string'
        } */
            console.log(req.query)
            const serviceExample = await app.services.servicesSample.callDynamoDBGetItem();
            res.send(JSON.stringify(serviceExample));
        })
}
