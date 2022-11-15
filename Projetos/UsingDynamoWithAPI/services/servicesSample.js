var _ = require('lodash');

module.exports = function (app) {

    this.callServicesGetTypeUrlAntigaItems = async function (params) {

        console.log(`dados entrando no services: ${JSON.stringify(params)}`);
        if (params.organizacao == undefined) {
            params.organizacao = "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79";
            console.log(`dados de organizacao inputados no services: ${JSON.stringify(params)}`);
        }

        let objectresponserepository = await app.repository.repositorySample.callDynamoDBGetAllItemsPorUnidadeOrganizacionalECodCli(params);
        let objectresponsemodel = await app.model.modelSample.callModelGetTypeUrlAntigaItems(JSON.parse(JSON.stringify(objectresponserepository)));

        return objectresponsemodel;


    }

    this.callServicesGetTypeComTodoItens = async function (params) {

        console.log(`dados entrando no services: ${JSON.stringify(params)}`);
        if (params.organizacao == undefined) {
            params.organizacao = "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79";
            console.log(`dados de organizacao inputados no services: ${JSON.stringify(params)}`);
        }

        let objectresponserepository = await app.repository.repositorySample.callDynamoDBGetAllItemsPorUnidadeOrganizacionalECodCli(params);
        let objectresponsemodel = await app.model.modelSample.callModelGetTypeComTodoItens(params, JSON.parse(JSON.stringify(objectresponserepository)));

        return objectresponsemodel;
    }

    this.callServicesGetTypeItemEspecifico = async function (params) {

        console.log(`dados entrando no services: ${JSON.stringify(params)}`);
        if (params.organizacao == undefined) {
            params.organizacao = "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79";
            console.log(`dados de organizacao inputados no services: ${JSON.stringify(params)}`);
        }

        let objectresponserepository = await app.repository.repositorySample.callDynamoDBGetAllItemsPorUnidadeOrganizacionalECodCli(params);
        let objectresponsemodel = await app.model.modelSample.callModelGetTypeComItemEspecifico(params, JSON.parse(JSON.stringify(objectresponserepository)));

        return objectresponsemodel;
    }

    this.callServicesDelete = async function (params) {

        console.log(`dados entrando no services: ${JSON.stringify(params)}`);
        if (params.organizacao == undefined) {
            params.organizacao = "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79";
            console.log(`dados de organizacao inputados no services: ${JSON.stringify(params)}`);
        }

        let objectresponserepositorysearchItems = await app.repository.repositorySample.callDynamoDBGetAllItemsPorUnidadeOrganizacionalECodCli(params);
        let objectresponsemodelDelete = await app.model.modelSample.callModelSendRepositoryDelete(params, JSON.parse(JSON.stringify(objectresponserepositorysearchItems)));

        if (objectresponsemodelDelete.length == 0) {
            return app.model.modelSample.callModelSendMessageDelete(false);
        } else {
            objectresponsemodelDelete.forEach(async (element) => {
                await app.repository.repositorySample.callDynamoDelete(element);
            });
        }
        return app.model.modelSample.callModelSendMessageDelete(true);

    }

    this.callServicesPost = async function (params) {

        console.log(`dados entrando no services: ${JSON.stringify(params)}`);
        if (params.organizacao == undefined) {
            params.organizacao = "58DD61E9-993D-4AA4-8AFB-78B5B55CDA79";
            console.log(`dados de organizacao inputados no services: ${JSON.stringify(params)}`);
        }

        await app.repository.repositorySample.callDynamoPost(params);
        return app.model.modelSample.callModelSendMessagePost(true);
    }

    return this;
}
