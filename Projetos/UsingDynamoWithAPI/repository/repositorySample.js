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

    this.callDynamoGetTypeUrlAntigaItems = async function (params) {
        console.log(`dados entrando no repositorio: ${JSON.stringify(params)}`);

        // var paramDynamo = {
        //     TableName: `${process.env.TABLENAME}`,
        //     Key: {
        //         "campo01Obj": "xmujr7ryw#00fld7j7l#5pir44f5c",
        //         "campo2Hash": "rd596ctsk"
        //     }


        // };
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
            KeyConditionExpression: 'campo1Obj = :hkey AND begins_with(campo3Hash, :rkey)',
            ExpressionAttributeValues: {
                ':hkey': `xmujr7ryw#${params.unid}`,
                ':rkey': `${params.cli}`
            }

        };
        const resp = await connectFac().query(paramDynamo).promise();

        return resp;
    }

    this.callDynamoGetTypeComTodoItens = async function (params) {
        console.log(`dados entrando no repositorio: ${JSON.stringify(params)}`);


        var paramDynamo = {
            TableName: `${process.env.TABLENAME}`,
            KeyConditionExpression: 'campo1Obj = :hkey AND begins_with(campo3Hash, :rkey)',
            ExpressionAttributeValues: {
                ':hkey': `${params.org}#${params.unid}`,
                ':rkey': `${params.cli}`
            }

        };
        const resp = await connectFac().query(paramDynamo).promise();

        return resp;
    }

    return this;
}
