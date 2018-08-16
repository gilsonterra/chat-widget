<chat-message>
    <style>
        :scope {
            margin: 16px 0;
        }

        h4,
        h5 {
            line-height: 1.5em;
            margin: 0;
        }

        img {
            border: 0;
            display: block;
            height: auto;
            max-width: 100%;
        }


        hr {
            background: #e9e9e9;
            border: 0;
            -moz-box-sizing: content-box;
            box-sizing: content-box;
            height: 1px;
            margin: 0;
            min-height: 1px;
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

        .chat-message img {
            border-radius: 50%;
            float: left;
        }

        .chat-message-content {
            margin-left: 56px;
        }

        .chat-time {
            float: right;
            font-size: 10px;
        }
    </style>

    <div class="chat-message clearfix">
        <img src="{ opts.icon }" alt="" width="32" height="32">
        <div class="chat-message-content clearfix">
            <span class="chat-time">{ opts.time.getHours() }:{ opts.time.getMinutes() }</span>
            <h5>{ opts.name }</h5>
            <p>{ opts.text }</p>
        </div>
    </div>
    <hr>
</chat-message>