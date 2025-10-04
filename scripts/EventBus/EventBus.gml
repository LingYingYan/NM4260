function EventBus() constructor {
    __private = {
        subscriptions: ds_map_create()
    }
    
    /// @desc Subscribes to an event
    /// @param {String} event The event
    /// @param {Function} callback The event callback
    static on_event = function(event, callback) {
        var listeners = self.__private.subscriptions[? event];
        if (is_undefined(listeners)) {
            listeners = ds_map_create();
            ds_map_add(listeners, callback, undefined);
            ds_map_add(self.__private.subscriptions, event, listeners);
        } else {
            ds_map_add(listeners, callback, undefined); 
        }
    }  
    
    /// @desc Broadcasts an event
    /// @param {Struct.Event} event The event
    static broadcast = function(event) {
        var listeners = self.__private.subscriptions[? event.type];
        if (!is_undefined(listeners)) {
            for_each_key_in_map(listeners, method({ event: event }, function(callback) {
                callback(event);  
            }));
        }
    } 
    
    /// @desc Unsubscribes an event
    /// @param {String} event The event
    /// @param {Function} callback The event callback to remove
    static mute = function(event, callback) {
        var listeners = self.__private.subscriptions[? event.type];
        if (!is_undefined(listeners)) {
            ds_map_delete(listeners, callback);
        }
    }
}



