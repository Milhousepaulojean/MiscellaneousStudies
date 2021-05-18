const fs = require('fs');

//Assincrono
fs.writeFile('arquivo.txt', 'Hello World!\n',{enconding:'utf-8',flag: 'a'}, function (err) {
    if (err) throw err;
});

fs.readFile('arquivo.txt', 'utf-8', function (err, data) {
    if(err) throw err;
    console.log(data);
});

//Sincrono
const dataSync = 'Testando a criação de arquivos de forma sincrona';
fs.writeFileSync('arquivo2.txt', dataSync, {enconding:'utf-8',flag: 'a'});
const data2 = fs.readFileSync('arquivo2.txt', {encoding:'utf8', flag:'r'});
console.log(data2)


//FLAG	DESCRIÇÃO
//r	    Abre o arquivo para leitura. Uma exceção ocorre se o arquivo não existe.
//r+	Abre o arquivo para leitura e escrita. Uma exceção ocorre se o arquivo não existe.
//rs	Arquivo aberto para leitura no modo síncrono.
//rs+	Arquivo aberto para leitura e escrita, contando a OS para abri-lo de forma síncrona.
//w	    Abre o arquivo para escrita. O arquivo é criado (se não existir) ou truncado (se existir).
//wx	Como ‘w’, mas não consegue se existe caminho.
//w+	Abre o arquivo para leitura e escrita. O arquivo é criado (se não existir) ou truncado (se existir).
//wx+	Como ‘w+’, mas não consegue se existe caminho.
//a	    Abre o arquivo para acrescentar. O arquivo é criado se ele não existe.
//ax	Como ‘a’, mas não consegue se existe caminho.
//a+	Abre o arquivo para leitura e acrescentando. O arquivo é criado se ele não existe.
//ax+	Como ‘a+’, mas não consegue se existe caminho. 