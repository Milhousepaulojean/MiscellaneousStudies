var _ = require('lodash');

module.exports = function (app) {

    this.callServicesPost = async function (params) {
        await app.repository.repositorySample.callDynamoPost(params);
        return app.model.modelSample.callModelSendMessagePost(true);
    }

    this.callServicesLimiteePaginacao = async function (paramreq) {

        return await app.repository.repositorySample.callDynamoGetLimitePaginacao(paramreq);

    }

    return this;
}
