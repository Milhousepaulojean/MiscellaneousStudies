module.exports = function(){
    
<<<<<<< HEAD
<<<<<<< HEAD
    this.getData = function(connection, callback){
=======
    this.getData(connection, callback){
>>>>>>> ada7cf1 (nodejs: Commit aplicado demonstra os estudo de node Utilizando Models com Consign .)
=======
    this.getData = function(connection, callback){
>>>>>>> c8e4a3b (nodejs: Commit aplicado demonstra os estudo de node com correcao na funcionalidade para pegar dados.)
        connection.query('select * from Persons;', callback);
    }

    return this;
}