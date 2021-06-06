$(function () {
    //make connection
    var socket = io.connect('http://localhost:3001')

    //buttons and inputs
    var message = $("#message")
    var username = $("#username")
    var send_message = $("#send_message")
    var send_username = $("#send_username")
    var chatroom = $("#chatroom")
    var feedback = $("#feedback")

    //1ª Fase
    socket.emit('toInit');  

    //Emit message
    send_message.click(function () {
        socket.emit('new_message', { message: message.val() })
    })

    //Listen on new_message
    socket.on("new_message", (data) => {
        feedback.html('');
        message.val('');
        chatroom.append("<p class='message'>" + data.username + ": " + data.message + "</p>")
    })

    //Emit a username
    send_username.click(function () {
        socket.emit('change_username', { username: username.val() })
    })

    //Emit typing
    message.bind("keypress", () => {
        socket.emit('typing')
    })

    //Listen on typing
    socket.on('typing', (data) => {
        feedback.html("<p><i>" + data.username + " is typing a message..." + "</i></p>")
    })

    //Init
    socket.on("toInit", (data) => {
        feedback.html('');
        message.val('');
        console.log(data)
        socket.token = '#001';
        chatroom.append("<p class='message'>" +data.responseMessage + "</p>");

        
    })

    socket.on("toInteractive", (data) => {
        feedback.html('');
        message.val('');
        chatroom.append("<p class='message'>" + data.username + ": " + data.message + "</p>");

        
    })

    socket.on("toEmitter", (data) => {
        chatroom.append("<p class='message'>" + data.username + ": " + data.message + "</p>");
    })

      var recursiva = function() {
        socket.emit('toEmitter');
        setTimeout(recursiva , 1000)
      }

      recursiva();

    
});