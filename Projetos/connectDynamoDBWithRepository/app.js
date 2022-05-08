const retornoRepositorio = require('./repositoryExample');
var resposta = retornoRepositorio.repositorioTabelaChamadaDeTodosOsItems();

resposta.then(data => {
    console.log(data)
})