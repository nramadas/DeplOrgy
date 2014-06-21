window.CDB = function() {
    var QUEUE_SIZE = 64;
    var QUEUE = new Array(QUEUE_SIZE);
    var OVERFLOW_BUFFER = new Array();
    var head_pointer = 0;
    var tail_pointer = 0;
    var resolving = false;

    var listeners = {};
    var responders = {};

    var add_fn_to_dict = function(fn, channel, dict) {
        if(!dict[channel]) { dict[channel] = []; }

        dict[channel].push(fn);
    };

    var remove_fn_from_dict = function(fn, channel, dict) {
        if(!dict[channel] || !dict[channel].length) { return; }

        fn_index = dict[channel].indexOf(fn);
        dict[channel].splice(fn_index, 1);
    };

    var increment_pointer = function(pointer) {
        return (pointer + 1) % QUEUE_SIZE;
    };


    var complete_event_in_queue = function(event_obj) {
        dict = event_obj.type == "responders" ? responders : listeners;
        fn_array = dict[event_obj.channel];

        if(!(fn_array && fn_array.length)) { return; }

        for(var i = 0; i < fn_array.length; i++) {
            fn_array[i].apply(null, event_obj.event);
        }
    };

    var resolve_queue = function() {
        if(resolving) { return; }

        resolving = true;

        if(OVERFLOW_BUFFER.length) {
            for(var i = 0; i < OVERFLOW_BUFFER.length; i++) {
                complete_event_in_queue(OVERFLOW_BUFFER[i]);
            }
        } else {
            while(tail_pointer != head_pointer) {
                complete_event_in_queue(QUEUE[tail_pointer]);
                tail_pointer = increment_pointer(tail_pointer);
            }

        }

        resolving = false;
    };

    var add_event_to_queue = function(type, channel, event) {
        event_obj = {type: type, channel: channel, event: event};

        if(increment_pointer(tail_pointer) == head_pointer) {
            OVERFLOW_BUFFER.push(event_obj);
        } else {
            QUEUE[head_pointer] = event_obj;
            head_pointer = increment_pointer(head_pointer);
        }
        resolve_queue();
    };

    return {
        listen: function(channel, fn) {
            add_fn_to_dict(fn, channel, listeners);
        },

        unlisten: function(channel, fn) {
            remove_fn_from_dict(fn, channel, listeners);
        },

        broadcast: function() {
            channel = Array.prototype.splice.call(arguments, 0, 1)[0];
            add_event_to_queue("listeners", channel, arguments);
        },

        respond: function(channel, fn) {
            add_fn_to_dict(fn, channel, responders);
        },

        unrespond: function(channel, fn) {
            remove_fn_from_dict(fn, channel, responders);
        },

        request: function(channel) {
            add_event_to_queue("responders", channel, []);
        }
    };
}();
