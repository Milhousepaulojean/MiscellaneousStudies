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
    socket.username = "Paulinho"

    socket.on('toInit', function (data) {
        var p1 = new Promise((resolve, reject) => {
            const SessionId = {
                url: 'http://localhost:3000/sendsession',
                method: 'GET'

            }

            
            request(SessionId, function (error, response, body) {

                var requisicao = JSON.parse(body);
                socket = requisicao;
                if (error === null && response.statusCode == 200) {
                    io.sockets.emit('toInit', { responseMessage: requisicao[0] });
                }
            });
        });

    });

    socket.on('toInteractive', (data) => {

        var formData = {
            key: data.key,
            affinityToken: data.affinityToken
        }

        const Messages = {
            url: 'http://localhost:3000/messages',
            method: 'GET',
            formData: formData
        }

        request(Messages, function (error, response, body) {
            if (error === null && response.statusCode == 200) {
                if (body != "") {

                    var requisicao = JSON.parse(body)
                    
                    
                    var posicao = requisicao.length;
               
                   

                    for (var indice = 0; indice < posicao; indice++) 
                    {
                        switch (requisicao[indice].type) {
                            case "ChatRequestFail":
                                
                                io.sockets.emit('toInteractive', { message: 'Central Indisponivel', username: 'Mensagem', eventSalesForce: 'ChatRequestFail' });
                                break;
                            case "ChatRequestSuccess":
                                    
                                io.sockets.emit('toInteractive', { message: 'Aguardando Atendimento', username: 'Mensagem', eventSalesForce: 'ChatRequestSuccess' });
                                break;
                            case "ChatEstablished":
                                   
                                io.sockets.emit('toInteractive', { message: 'Operador com sucesso', username: 'Mensagem', eventSalesForce: 'ChatEstablished' });
                                break;
                            case "AgentTyping":
                                    
                                io.sockets.emit('toInteractive', { message: 'Operador digitando', username: 'operador', eventSalesForce: 'AgentTyping' });
                                break;
                            case "AgentNotTyping":
                                    
                                io.sockets.emit('toInteractive', { message: 'Operador parou de digitar', username: 'operador', eventSalesForce: 'AgentNotTyping' });
                                break;
                            case "ChatMessage":
                                    
                                io.sockets.emit('toInteractive', { message: requisicao[indice].message.text, username: 'operador', eventSalesForce: 'ChatMessage' });
                                
                                break;
                            case "ChatEnded":
                                    
                                io.sockets.emit('toInteractive', { message: 'Operador Desconectou', username: 'operador', eventSalesForce: 'ChatEnded' });
                                break;
                            default:
                                console.log(requisicao[indice].message);
                            break;
                        }
                            
                    }
                
                  
                 
                }
            }
        })


     });

    // socket.on('toEmitter', (data) => {

    //   var formData = {
    //         key: data.key,
    //         affinityToken: data.affinityToken,
    //         mensagem: data.message, 
    //         sequence: data.sequence
    //     }

    //     const ChatMessage = {
    //         url: 'http://localhost:51867/bw6_messenger_cartao/SalesForce/ChatMessage',                 
    //         method: 'POST',
    //         formData: formData
    //     }
    //     request(ChatMessage, function (error, response,body) {

    //         if (error === null && response.statusCode == 200) 
    //         {
    //             io.sockets.emit('toEmitter', {message: data.message , username: 'Carlinhos', sequence: ((parseInt(data.sequence) + 1)) });
    //         }
    //     });
    // });

});