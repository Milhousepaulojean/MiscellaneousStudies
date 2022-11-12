module.exports = function (app) {
    // #swagger.parameters['id'] = { description: 'ID do usuário.' }
    app.get('/', async function (req, res) {
        const serviceExample = await app.services.servicesSample;
        res.send(serviceExample)
    })
}
