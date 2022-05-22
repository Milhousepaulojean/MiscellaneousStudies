module.exports = function(app){
    this.callServicesExample = (variable) =>{
        console.log(`Recebendo variavel ${variable}`);
        let retorno =  app.repository.repositorySample.callRepository();
        console.log(`Camada repositorio ${retorno}`);
        return retorno
    }

    return this;
}
