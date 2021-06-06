var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// Aqui iremos configura um modelo e depois usar o module.exports:
module.exports = mongoose.model('Usuario', new Schema({
        nome: String,
        senha: String,
        admin: Boolean
}));