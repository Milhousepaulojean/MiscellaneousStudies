var jwt = require('jsonwebtoken');
var config = require('../config');

module.exports = function (app) {

    this.authorization = async function (params) {
        console.log(`dados entrando no authorization: ${JSON.stringify(params)}`);
        //let tokenencrypt = await app.middlewares.crypto.encrypt(JSON.stringify(params))
        var token = jwt.sign({ params }, config.secret, {
            expiresIn: '30s'
        });

        console.log(`dados convertidos no authorization: ${JSON.stringify(token)}`);
        return token;
    }

    this.authentication = async function (params) {
        try {
            console.log(`dados entrando no authentication: ${JSON.stringify(params.token)}`);
            const verified = jwt.verify(params.token, config.secret, function (err, decoded) {
                if (err) {
                    throw new Error(err)
                } else {
                    return decoded;
                }
            });
            //return await app.middlewares.crypto.decrypt(verified)
            return verified
        } catch (error) {
            throw new Error(error.message)
        }
    }

    return this;
}
