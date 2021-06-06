/* Step 1. Importar as configurações do Servidor; */
var app = require('./config/server');

/* Step 2. Parametrizar a porta da escuta; */
app.listen(3000,function(){
    console.log('Servidor On')
})