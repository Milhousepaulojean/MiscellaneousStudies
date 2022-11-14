var _ = require('lodash');

module.exports = function (app) {

    this.callServicesGetTypeUrlAntigaItems = async function (params) {
        console.log(`dados entrando no services: ${JSON.stringify(params)}`);

        let object = await app.repository.repositorySample.callDynamoGetTypeUrlAntigaItems(params);
        let objectjson = JSON.parse(JSON.stringify(object));

        let i = 1;
        let j = 1;
        objectjson.Items.map(objItem => {
            switch (objItem["campo2Fri"]) {
                case "5pir44f5c":
                    i++;
                    break;
                case "6uafwkkw8":
                    j++;
                    break;
                default:
                    j;
                    break;
            }

        });

        let objresponse = {};
        objresponse.total = i + j;
        objresponse.totalA = j;
        objresponse.totalB = i;

        //console.log(`count total amigo: ${i}, \n count total sem amigo: ${j}`)
        return objresponse;
    }

    this.callServicesGetTypeComTodoItens = async function (params) {
        console.log(`dados entrando no services: ${JSON.stringify(params)}`);

        params.org = "xmujr7ryw";
        let object = await app.repository.repositorySample.callDynamoGetTypeComTodoItens(params);
        let objectjson = JSON.parse(JSON.stringify(object));

        console.log(objectjson)

        //Remove duplicates
        let uniqueChars = [...new Set(_.map(objectjson.Items, "campo2Fri"))];
        console.log(uniqueChars);

        let objresponse = {};


        objectjson.Items.map(function (item, index) {
            console.log(index)
        })

        objresponse.org = params.org;
        objresponse.unid = params.unid;
        objresponse.cli = params.cli;
        objresponse.total = objectjson.Count;
        //console.log(`count total amigo: ${i}, \n count total sem amigo: ${j}`)
        return objresponse;
    }

    return this;
}
