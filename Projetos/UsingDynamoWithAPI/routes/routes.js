const { json } = require("body-parser");

module.exports = function (app) {
       app.post('/inseriritem', async function (req, res) {
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
              res.send(JSON.parse(JSON.stringify(serviceExample)))
       })

       app.get('/getcomLimite_pagincao', async function (req, res) {

              /*  #swagger.parameters['nome'] = {
          in: 'query',
          description: 'Nome.',
              } */

              /*  #swagger.parameters['email'] = {
        in: 'query',
        description: 'email.',
              } */

              const serviceExample = await app.services.servicesSample.callServicesLimiteePaginacao(req.query);
              res.send(JSON.parse(JSON.stringify(serviceExample)))
       })
}
