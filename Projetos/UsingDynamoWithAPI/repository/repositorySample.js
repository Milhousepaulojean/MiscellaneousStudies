require('dotenv').config()


const connectFac = require('../middleware/middlewareSample');

module.exports = function (app) {
    this.callDynamoDBGetAllItems = async function () {
        //        console.log("repositorio");
        // const params = {
        //     TableName: process.env.TABLENAME
        // };
        // return await connectFac().scan(params).promise();
    }

    this.callDynamoGetTypeComTodoItens = async function (params) {
        console.log(`dados entrando no repositorio: ${JSON.stringify(params)}`);


        var paramDynamo = {
            TableName: `${process.env.TABLENAME}`,
            KeyConditionExpression: 'campo1Obj = :hkey AND begins_with(campo3Hash, :rkey)',
            ExpressionAttributeValues: {
                ':hkey': `${params.org}#${params.unid}`,
                ':rkey': `${params.cod_cli}`
            }

        };
        const resp = await connectFac().query(paramDynamo).promise();

        return resp;
    }

    this.callDynamoDBGetAllItemsPorUnidadeOrganizacionalECodCli = async function (params) {
        console.log(`dados entrando no repositorio: ${JSON.stringify(params)}`);


        //const resp = await connectFac().get(paramDynamo).promise();

        // var paramDynamo = {
        //     TableName: `${process.env.TABLENAME}`,
        //     KeyConditionExpression: 'campo01Obj = :hkey and campo2Hash = :rkey',
        //     ExpressionAttributeValues: {
        //         ':hkey': 'xmujr7ryw#00fld7j7l#5pir44f5c',
        //         ':rkey': "rd596ctsk#2022-10-21T17:42:34+00:00"
        //     }

        // };
        // const resp = await connectFac().query(paramDynamo).promise();

        //uso do operador like para begins_with
        // var paramDynamo = {
        //     TableName: `${process.env.TABLENAME}`,
        //     KeyConditionExpression: 'campo1Obj = :hkey AND begins_with(campo3Hash, :rkey)',
        //     ExpressionAttributeValues: {
        //         ':hkey': 'xmujr7ryw#00fld7j7l',
        //         ':rkey': "rd596ctsk"
        //     }

        // };
        // const resp = await connectFac().query(paramDynamo).promise();



        var paramDynamo = {
            TableName: `${process.env.TABLENAME}`,
            KeyConditionExpression: 'cod_objt_patc_mens = :hkey AND begins_with(cod_objt_cli, :rkey)',
            ExpressionAttributeValues: {
                ':hkey': `${params.organizacao}#${params.unidade_organizacional}`,
                ':rkey': `${params.cod_cli}`
            }

        };
        const resp = await connectFac().query(paramDynamo).promise();

        return resp;
    }

    this.callDynamoDelete = async function (params) {
        console.log(`dados entrando no repositorio: ${JSON.stringify(params)}`);

        var paramDynamo = {
            TableName: `${process.env.TABLENAME}`,
            Key: {
                'cod_objt_patc_mens': `${params.organizacao}#${params.unidade_organizacional}`,
                'cod_objt_cli': `${params.cod_cli}`
            }
        };

        const resp = await connectFac().delete(paramDynamo).promise();

        return resp;
    }

    this.callDynamoPost = async function (params) {
        console.log(`dados entrando no repositorio: ${JSON.stringify(params)}`);

        var datetime = new Date();
        var paramDynamo = {
            TableName: `${process.env.TABLENAME}`,
            Item: {
                'cod_objt_patc_mens': `${params.organizacao}#${params.unidade_organizacional}`,
                'cod_objt_cli': `${params.cod_clie}#${datetime.toJSON().toString()}}`,
                'cod_objt_aten': `${params.chatbot}`,
                'cod_objt_clsr_mens': `${params.cod_mens}`,
                'cod_objt_mens': `${params.tip_rem}`,
                'nom_apel_remt': `${params.nome_rem}`
            }
        };

        const resp = await connectFac().put(paramDynamo).promise();

        return resp;
    }

    return this;
}
