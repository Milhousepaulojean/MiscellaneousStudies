var jwt = require('jsonwebtoken');
var config = require('../config');

module.exports = function (app) {

    this.authorization = async function (params) {
        console.log(`dados entrando no authorization: ${JSON.stringify(params)}`);
        let tokenencrypt = await app.middlewares.crypto.encrypt(JSON.stringify(params))
        var token = jwt.sign({ tokenencrypt }, config.secret, {
            expiresIn: '1m'
        });

        console.log(`dados convertidos no authorization: ${JSON.stringify(token)}`);
        return token;
    }

    this.authentication = async function (params) {
        console.log(`dados entrando no authentication: ${JSON.stringify(params.token)}`);
        const verified = jwt.verify(params.token, config.secret, function (err, decoded) {
            if (err) {
                return err;
            } else {
                return decoded;
            }
        });
        return await app.middlewares.crypto.decrypt(verified)


    }

    return this;
}
