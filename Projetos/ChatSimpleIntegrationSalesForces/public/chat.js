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
    var sequence = $("#sequence")
    var process= false;
    

    //1ª Fase
    socket.emit('toInit');

    //Emit message
    // send_message.click(function () {
    //     socket.emit('toEmitter', { message: message.val(), key: $('#key').val(), affinityToken: $('#affinityToken').val() , sequence: $('#sequence').val() })
    //     console.log("send_message")
    //     process == false
    // })

    //Init
    socket.on("toInit", (data) => {
        feedback.html('');
        message.val('');
        // chatroom.append("<p class='message'>" + data.responseMessage + "</p>");
        console.log("toInit")
        $('#key').val(data.responseMessage.key);
        $('#affinityToken').val(data.responseMessage.affinityToken);
        process == false

    })

    socket.on("toInteractive", (data) => {
        feedback.html('');
        console.log("toInteractive")
        chatroom.append("<p class='message'>" + data.username + ": " + data.message + "</p>");
        process == false
    })


    // socket.on("toEmitter" , (data) => {
    //     feedback.html('');
    //     message.val('');
    //     sequence.val(data.sequence)           
    //     console.log("toEmitter")
    //     chatroom.append("<p class='message'>" + data.username + ": " + data.message + "</p>")
    //     process == false
    // })




    var i = 0, loop_length = 3000, loop_speed = 6000;

    function loop() {
        i += 1;
        console.log(process)
        var key = $('#key').val();
        var affinityToken = $('#affinityToken').val();

        if (key != '' && process == false) {

            if(chatroom.val() != "Aguardando Atendimento"){
                process = true;
                socket.emit('toInteractive', { key: key, affinityToken: affinityToken });
            }
            
        }

        if (i === loop_length) clearInterval(handler);
    }

    var handler = setInterval(loop, loop_speed);
    setInterval(loop, loop_speed);


});




