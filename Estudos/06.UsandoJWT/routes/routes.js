module.exports = function (app) {
    app.get('/', function (req, res) {
        const serviceExample = app.services.servicesSample;
        res.send(serviceExample)
    })

    app.post('/inserir', async function (req, res) {
        /*  #swagger.parameters['obj'] = {
                             in: 'body',
                             description: 'Some description...',
                             schema: {
                                         nome: 'Paulo Sila',
                                         email: 'paulo@paulo.com',
                                         end: 'rua das pintobeiras, 3',
                                         cidade: 'guarulhos',
                                         estado: 'sp'
                                     }
                     } */
        console.log(`dados entrando no routes: ${JSON.stringify(req.body)}`);
        const serviceExample = await app.services.servicesSample.callServicesPost(req.body);

        const exampleauthorization = await app.middlewares.auth.authorization(serviceExample)
        res.send(exampleauthorization)
    })

    app.get('/verifica', async function (req, res) {
        /*  #swagger.parameters['token'] = {
          in: 'query',
          description: 'Nome.',
              } */
        const exampleauthorization = await app.middlewares.auth.authentication(req.query)
        res.send(exampleauthorization)
    })
}
