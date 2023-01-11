require('dotenv').config()


//const connectFac = require('../middleware/middlewareSample');

module.exports = function (app) {
    this.callDynamoGetLimitePaginacao = async function (paramreq) {
        console.log("repositorio");
        const params = {
            TableName: "ExampleTable",
            Limit: 2,
        };

        if (JSON.stringify(paramreq) != "{}") {
            params.ExclusiveStartKey = { nome: paramreq.nome, email: paramreq.email }
        }

        const connectFac = app.middleware.middlewareSample;
        return await connectFac.scan(params).promise();
    }


    this.callDynamoPost = async function (params) {
        console.log(`dados entrando no repositorio: ${JSON.stringify(params)}`);

        var datetime = new Date();
        var paramDynamo = {
            TableName: `${process.env.TABLENAME}`,
            Item: {
                'nome': `${params.nome}`,
                'email': `${params.email}`,
                'end': `${params.chatbot}`,
                'cidade': `${params.cod_mens}`,
                'estado': `${params.tip_rem}`,
            }
        };

        const resp = await connectFac().put(paramDynamo).promise();

        return resp;
    }

    return this;
}
