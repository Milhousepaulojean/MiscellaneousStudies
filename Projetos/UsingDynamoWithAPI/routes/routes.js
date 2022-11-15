const { json } = require("body-parser");

module.exports = function (app) {
    // #swagger.parameters['id'] = { description: 'ID do usuário.' }
    app.get('/listarmensagenspendentesdeconvivencia', async function (req, res) {
        /*  #swagger.parameters['organizacao'] = {
               in: 'query',
               description: 'Some description...'
        } */

        /*  #swagger.parameters['unidade_organizacional'] = {
               in: 'query',
               description: 'Some description...'
        } */

        /*  #swagger.parameters['cod_cli'] = {
               in: 'query',
               description: 'Some description...'
        } */
        console.log(`dados entrando no routes: ${JSON.stringify(req.query)}`);
        const serviceExample = await app.services.servicesSample.callServicesGetTypeUrlAntigaItems(req.query);
        res.send(JSON.parse(JSON.stringify(serviceExample)))

    })

    app.get('/urlnovacomtodoitens', async function (req, res) {
        /*  #swagger.parameters['organizacao'] = {
               in: 'query',
               description: 'Some description...'
        } */

        /*  #swagger.parameters['unidade_organizacional'] = {
               in: 'query',
               description: 'Some description...'
        } */

        /*  #swagger.parameters['cod_cli'] = {
               in: 'query',
               description: 'Some description...'
        } */
        console.log(`dados entrando no routes: ${JSON.stringify(req.query)}`);
        const serviceExample = await app.services.servicesSample.callServicesGetTypeComTodoItens(req.query);
        res.send(JSON.parse(JSON.stringify(serviceExample)))

    })

    app.get('/urlnovacomitemespecifico', async function (req, res) {
        /*  #swagger.parameters['organizacao'] = {
               in: 'query',
               description: 'Some description...'
        } */

        /*  #swagger.parameters['unidade_organizacional'] = {
               in: 'query',
               description: 'Some description...'
        } */

        /*  #swagger.parameters['cod_cli'] = {
               in: 'query',
               description: 'Some description...'
        } */

        /*  #swagger.parameters['chatbot'] = {
               in: 'query',
               description: 'Some description...'
        } */
        console.log(`dados entrando no routes: ${JSON.stringify(req.query)}`);
        const serviceExample = await app.services.servicesSample.callServicesGetTypeItemEspecifico(req.query);
        res.send(JSON.parse(JSON.stringify(serviceExample)))
    })

    app.delete('/urldeletaitem/:unidade_organizacional/:cod_cli/:chatbot', async function (req, res) {
        console.log(`dados entrando no routes: ${JSON.stringify(req.params)}`);
        const serviceExample = await app.services.servicesSample.callServicesDelete(req.params);
        res.send(JSON.parse(JSON.stringify(serviceExample)))
    })

    app.post('/inseriritem', async function (req, res) {
        /*  #swagger.parameters['obj'] = {
                        in: 'body',
                        description: 'Some description...',
                        schema: {
                                    organizacao: '58DD61E9-993D-4AA4-8AFB-78B5B55CDA79',
                                    unidade_organizacional: '6FC300C4-1207-49A6-AE49-D584133C8624',
                                    chatbot: '8F8C717A-BFFC-4BFA-8E04-605361410172',
                                    cod_clie: '32679660862',
                                    cod_mens: '7D353B04-AC34-46A0-80E8-C1CBA1A15BC3',
                                    tip_rem: 'agent',
                                    nome_rem: 'Fulano de tal 2',
                                    origem: 'iumessenger'
                                }
                } */
        console.log(`dados entrando no routes: ${JSON.stringify(req.body)}`);
        const serviceExample = await app.services.servicesSample.callServicesPost(req.body);
        res.send(JSON.parse(JSON.stringify(serviceExample)))
    })
}
