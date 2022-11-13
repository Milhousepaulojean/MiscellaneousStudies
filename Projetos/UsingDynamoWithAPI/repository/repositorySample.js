const connectFac = require('../middleware/middlewareSample');

module.exports = function (app) {
    this.callDynamoDBGetAllItems = async function () {
        //        console.log("repositorio");
        // const params = {
        //     TableName: process.env.TABLENAME
        // };
        // return await connectFac().scan(params).promise();
    }


    this.callDynamoGetTypeUrlAntigaItems = async function () {

        return "ok repositorio"
    }

    return this;
}
