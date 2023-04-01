var crypto = require('crypto');
const algorithm = 'aes-256-cbc';
const key = crypto.randomBytes(32);
const iv = crypto.randomBytes(16);
var config = require('../config');

module.exports = function (app) {
    this.encrypt = async function (params) {
        let cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(key), iv);
        let encrypted = cipher.update(params);
        encrypted = Buffer.concat([encrypted, cipher.final()]);
        let hw = { iv: iv.toString('hex'), encryptedData: encrypted.toString('hex') }
        console.log(`dados entrando no encrypt: ${JSON.stringify(hw)}`);
        return hw;
    }

    this.decrypt = async function (params) {
        let iv = Buffer.from(params.tokenencrypt.iv, 'hex');
        let encryptedText = Buffer.from(params.tokenencrypt.encryptedData, 'hex');
        let decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(key), iv);
        let decrypted = decipher.update(encryptedText);
        decrypted = Buffer.concat([decrypted, decipher.final()]);
        console.log(`dados entrando no decrypt: ${JSON.stringify(decrypted)}`);
        return decrypted.toString();
    }

    return this;
}