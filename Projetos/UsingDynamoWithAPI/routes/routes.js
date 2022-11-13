const { json } = require("body-parser");

module.exports = function (app) {
    // #swagger.parameters['id'] = { description: 'ID do usuário.' }
    app.get('/urlantiga/:unid/:cli', async function (req, res) {
        console.log(`dados entrando no routes: ${JSON.stringify(req.params)}`);
        const serviceExample = await app.services.servicesSample.callServicesGetTypeUrlAntigaItems(req.params);
        res.send(serviceExample)
    })

    app.get('/urlnovacomtodoitens/:unidade/:cli', async function (req, res) {
        //const serviceExample = await app.services.servicesSample;
        //res.send(serviceExample)
    })

    app.get('/urlnovacomtodoitemespecifico/:unidade/:ami/:cli/', async function (req, res) {
        //const serviceExample = await app.services.servicesSample;
        //res.send(serviceExample)
    })

    app.delete('/urldeletaitem/:unidade/:ami', async function (req, res) {
        //const serviceExample = await app.services.servicesSample;
        //res.send(serviceExample)
    })

    app.post('/inseriritem', async function (req, res) {
        //const serviceExample = await app.services.servicesSample;
        //res.send(serviceExample)
    })
}
