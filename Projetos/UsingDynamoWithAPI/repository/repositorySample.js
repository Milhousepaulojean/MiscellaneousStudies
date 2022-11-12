const connectFac = require('../middleware/middlewareSample');

module.exports = function (app) {
    this.callDynamoDBGetAllItems = async function () {
        const params = {
            TableName: process.env.TABLENAME
        };
        return await connectFac().scan(params).promise();
    }

    return this;
}
