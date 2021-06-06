const express = require('express')
const request = require('request')
const app = express()


//set the template engine ejs
app.set('view engine', 'ejs')

//middlewares
app.use(express.static('public'))


//routes
app.get('/', (req, res) => {
	res.render('index')
})

//Listen on port 3000
server = app.listen(3001)



//socket.io instantiation
const io = require("socket.io")(server)


//listen on every connection
io.on('connection', (socket) => {
	//console.log('New user connected')

	//default username
	socket.username = "Carlinhos"

    socket.on('toInit', (data) => {
        request('http://localhost:3000/messagesFail', function (error, response, body) {
           // console.log('error:', error); // Print the error if one occurred
           // console.log('statusCode:', response && response.statusCode); // Print the response status code if a response was received
           // console.log('body:', body); // Print the HTML for the Google homepage.
           
            if(error === null && response.statusCode == 200){

                switch(JSON.parse(response.body)[0].messages[0].type){
                    case 'ChatRequestFail':                        
                            io.sockets.emit('toInit', {responseMessage : 'Central Indisponviel no Momento.' , responseJson: JSON.parse(response.body) });
                    break;                   
                    default:
                            io.sockets.emit('toInit', {responseMessage : 'Error' , responseJson: JSON.parse(response.body) });
                        break;
                }   
            }else{
                io.sockets.emit('toInit', {response : "Serviço Indisponivel"});
            }
            
        });
    })

    socket.on('toEmitter', (data) => {
        //broadcast the new message
        io.sockets.emit('toEmitter', {message : 'oi', username : 'Operador'});
    })

    //listen on new_message
    socket.on('new_message', (data) => {
        //broadcast the new message
        io.sockets.emit('new_message', {message : data.message, username : socket.username});
    })

    //listen on typing
    socket.on('typing', (data) => {
    	socket.broadcast.emit('typing', {username : socket.username})
    })
})