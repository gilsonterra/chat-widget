<chat>
    <style>
        :scope {
            color: #9a9a9a;
            font: 100%/1.5em "Droid Sans", sans-serif;
            margin: 0;
        }

        .hide {
            display: none;
        }

        .show {
            display: block;
        }

        .fade-out {
            opacity: 0;
            transition: visibility 0s 2s, opacity 2s linear;
        }

        .fade-in {
            -webkit-animation: fadein 2s;
            /* Safari, Chrome and Opera > 12.1 */
            -moz-animation: fadein 2s;
            /* Firefox < 16 */
            -ms-animation: fadein 2s;
            /* Internet Explorer */
            -o-animation: fadein 2s;
            /* Opera < 12.1 */
            animation: fadein 2s;
        }

        .slide-out {
            -webkit-transition: height .5s ease;
            height: 0;
            overflow: hidden;
        }

        .slide-in {
            -webkit-transition: height .5s ease;
            overflow: auto;
        }

        a {
            text-decoration: none;
        }

        .clearfix {
            *zoom: 1;
        }

        /* For IE 6/7 */

        .clearfix:before,
        .clearfix:after {
            content: "";
            display: table;
        }

        .clearfix:after {
            clear: both;
        }

        fieldset {
            border: 0;
            margin: 0;
            padding: 0;
        }

        input {
            border: 0;
            color: inherit;
            font-family: inherit;
            font-size: 100%;
            line-height: normal;
            margin: 0;
        }

        p {
            margin: 0;
        }

        /* ---------- LIVE-CHAT ---------- */

        :scope {
            bottom: 0;
            font-size: 12px;
            right: 24px;
            position: fixed;
            width: 300px;
        }

        :scope header {
            background: #293239;
            border-radius: 5px 5px 0 0;
            color: #fff;
            cursor: pointer;
            padding: 16px 24px;
        }

        :scope h4:before {
            background: #1a8a34;
            border-radius: 50%;
            content: "";
            display: inline-block;
            height: 8px;
            margin: 0 8px 0 0;
            width: 8px;
        }

        :scope h4 {
            font-size: 12px;
        }

        :scope h5 {
            font-size: 10px;
        }

        :scope form {
            padding: 24px;
        }

        :scope input[type="text"] {
            border: 1px solid #ccc;
            border-radius: 3px;
            padding: 8px;
            outline: none;
            width: 234px;
        }

        .chat-message-counter {
            background: #e62727;
            border: 1px solid #fff;
            border-radius: 50%;
            font-size: 12px;
            font-weight: bold;
            height: 28px;
            left: 0;
            line-height: 28px;
            margin: -15px 0 0 -15px;
            position: absolute;
            text-align: center;
            top: 0;
            width: 28px;
        }

        .chat-close {
            background: #1b2126;
            border-radius: 50%;
            color: #fff;
            display: block;
            float: right;
            font-size: 10px;
            height: 16px;
            line-height: 16px;
            margin: 2px 0 0 0;
            text-align: center;
            width: 16px;
        }

        .chat {
            background: #fff;
            border: solid 1px #ccc;
        }

        .chat-history {
            height: 252px;
            padding: 8px 24px;
            overflow-y: scroll;
        }
    </style>

    <div id="live-chat">
        <header class="clearfix" onClick="{ headerOnClick }">
            <a href="#" class="chat-close" onClick="{ chatCloseOnClick }">x</a>
            <h4>{ user.name }</h4>
            <span class="chat-message-counter hide" ref="counter">{ messages.length }</span>
        </header>
        <div class="chat" ref="chat">
            <div class="chat-history">
                <chat-message each="{ m in messages }" icon="{ m.icon }" name="{ m.name }" text="{ m.text }" time="{ m.time }"></chat-message>
            </div>
            <chat-feedback></chat-feedback>
            <form onsubmit="{ onSubmit }" method="post">
                <fieldset>
                    <input type="text" placeholder="Type your message…" ref="inputMessage" autofocus>
                    <input type="hidden">
                </fieldset>
            </form>
        </div>
    </div>

    <script>
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
    </script>
</chat>