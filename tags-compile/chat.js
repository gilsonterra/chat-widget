riot.tag2('chat', '<div id="live-chat"><header class="clearfix" onclick="{headerOnClick}"><a href="#" class="chat-close" onclick="{chatCloseOnClick}">x</a><h4>{user.name}</h4><span class="chat-message-counter hide" ref="counter">{messages.length}</span></header><div class="chat" ref="chat"><div class="chat-history"><chat-message each="{m in messages}" icon="{m.icon}" name="{m.name}" text="{m.text}" time="{m.time}"></chat-message></div><chat-feedback></chat-feedback><form onsubmit="{onSubmit}" method="post"><fieldset><input type="text" placeholder="Type your message…" ref="inputMessage" autofocus><input type="hidden"></fieldset></form></div></div>', 'chat,[data-is="chat"]{ color: #9a9a9a; font: 100%/1.5em "Droid Sans", sans-serif; margin: 0; } chat .hide,[data-is="chat"] .hide{ display: none; } chat .show,[data-is="chat"] .show{ display: block; } chat .fade-out,[data-is="chat"] .fade-out{ opacity: 0; transition: visibility 0s 2s, opacity 2s linear; } chat .fade-in,[data-is="chat"] .fade-in{ -webkit-animation: fadein 2s; -moz-animation: fadein 2s; -ms-animation: fadein 2s; -o-animation: fadein 2s; animation: fadein 2s; } chat .slide-out,[data-is="chat"] .slide-out{ -webkit-transition: height .5s ease; height: 0; overflow: hidden; } chat .slide-in,[data-is="chat"] .slide-in{ -webkit-transition: height .5s ease; overflow: auto; } chat a,[data-is="chat"] a{ text-decoration: none; } chat .clearfix,[data-is="chat"] .clearfix{ *zoom: 1; } chat .clearfix:before,[data-is="chat"] .clearfix:before,chat .clearfix:after,[data-is="chat"] .clearfix:after{ content: ""; display: table; } chat .clearfix:after,[data-is="chat"] .clearfix:after{ clear: both; } chat fieldset,[data-is="chat"] fieldset{ border: 0; margin: 0; padding: 0; } chat input,[data-is="chat"] input{ border: 0; color: inherit; font-family: inherit; font-size: 100%; line-height: normal; margin: 0; } chat p,[data-is="chat"] p{ margin: 0; } chat,[data-is="chat"]{ bottom: 0; font-size: 12px; right: 24px; position: fixed; width: 300px; } chat header,[data-is="chat"] header{ background: #293239; border-radius: 5px 5px 0 0; color: #fff; cursor: pointer; padding: 16px 24px; } chat h4:before,[data-is="chat"] h4:before{ background: #1a8a34; border-radius: 50%; content: ""; display: inline-block; height: 8px; margin: 0 8px 0 0; width: 8px; } chat h4,[data-is="chat"] h4{ font-size: 12px; } chat h5,[data-is="chat"] h5{ font-size: 10px; } chat form,[data-is="chat"] form{ padding: 24px; } chat input[type="text"],[data-is="chat"] input[type="text"]{ border: 1px solid #ccc; border-radius: 3px; padding: 8px; outline: none; width: 234px; } chat .chat-message-counter,[data-is="chat"] .chat-message-counter{ background: #e62727; border: 1px solid #fff; border-radius: 50%; font-size: 12px; font-weight: bold; height: 28px; left: 0; line-height: 28px; margin: -15px 0 0 -15px; position: absolute; text-align: center; top: 0; width: 28px; } chat .chat-close,[data-is="chat"] .chat-close{ background: #1b2126; border-radius: 50%; color: #fff; display: block; float: right; font-size: 10px; height: 16px; line-height: 16px; margin: 2px 0 0 0; text-align: center; width: 16px; } chat .chat,[data-is="chat"] .chat{ background: #fff; border: solid 1px #ccc; } chat .chat-history,[data-is="chat"] .chat-history{ height: 252px; padding: 8px 24px; overflow-y: scroll; }', '', function(opts) {
        var tag = this;
        tag.user = {};
        tag.messages = [];
        tag.onSubmit = onSubmit;
        tag.headerOnClick = headerOnClick;
        tag.chatCloseOnClick = chatCloseOnClick;
        tag.on('mount', onMount);

        function onMount() {
            _getUserData();
            _getMessages();
        }

        function headerOnClick(event) {
            var chat = tag.refs.chat;
            var messageCounter = tag.refs.counter;

            if (chat.classList.contains('slide-out')) {
                chat.classList.remove('slide-out')
                chat.classList.add('slide-in');

                messageCounter.classList.remove('show');
                messageCounter.classList.add('hide');
            } else {
                chat.classList.remove('slide-in')
                chat.classList.add('slide-out');

                messageCounter.classList.remove('hide');
                messageCounter.classList.add('show');
            }
        }

        function chatCloseOnClick(event) {
            event.preventDefault();
            document.querySelector('#live-chat').classList.add('fade-out');
        }

        function onSubmit(event) {
            event.preventDefault();

            var message = {
                'name': tag.user.name,
                'icon': tag.user.icon,
                'text': tag.refs.inputMessage.value,
                'time': new Date()
            };
            tag.messages.push(message);
            tag.update();

            tag.refs.inputMessage.value = '';
        }

        function _getUserData() {
            fetch('https://pt.gravatar.com/27b3414d44b4e91271a5f4e80fbcc216.json')
                .then(function (response) {
                    return response.json();
                }).then(function (json) {
                    var entry = json.entry[0];
                    tag.update({
                        'user': {
                            'name': entry.displayName,
                            'icon': entry.thumbnailUrl
                        }
                    });
                });
        }

        function _getMessages() {
            fetch('https://us-central1-startupdareal-startups.cloudfunctions.net/spreadsheetToJson')
                .then(function (response) {
                    return response.json();
                })
                .then(function (json) {
                    var messages = json.map(function(message){
                        return {
                            'text': message['comentário'],
                            'date': new Date(),
                            'name': message['nomeDaEmpresa']
                        }
                    });
                    console.log(messages);
                    tag.update({'messages': messages});
                });
        }
});