module.exports = function(app){
    this.callServicesExample = () =>{
        return app.repository.repositorySample;
    }

    return this;
}
