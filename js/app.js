var chat = document.createElement('chat');
document.body.appendChild(chat);

setTimeout(function(){ 
    riot.mount('chat');
 }, 500);