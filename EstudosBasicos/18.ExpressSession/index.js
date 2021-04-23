const express = require('express')
const session = require('express-session')

const app = express()
app.use(session({
  'secret': 'testingSession'
}))

app.get('/', (req, res, next) => {
    req.session.name = 'Flavio'
    res.send(req.session.name);
  });

  app.listen(3000, function(){
    console.log('Servidor onLine.');
  })