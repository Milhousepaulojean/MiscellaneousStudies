var mysql = require('mysql');

var connMySql = function(){
    console.log('Carregando configuracao')
    return mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: 'password',
        database: 'case_study01'
    })
}

module.exports = function(){
    console.log('Carregando variavel de conexao')
    return connMySql;
}