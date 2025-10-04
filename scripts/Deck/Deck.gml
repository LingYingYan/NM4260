/// ---------------------------------------------------------------------------
/// Deck constructor
/// Keeps a map of owned cards: key = card object (object index), value = count.
/// ---------------------------------------------------------------------------
function Deck() constructor {
    __private = {
        map: ds_map_create()
    };

    /// Add copies of a card to the deck (adds to existing count).
    /** @param {Asset.GMObject} card_obj  Card object (object index) */
    /** @param {real} count       Number of copies to add (defaults to 1) */
    static add = function(card_obj, count = 1) {
        if (ds_map_exists(self.__private.map, card_obj)) {
            var prev = ds_map_find_value(self.__private.map, card_obj);
            ds_map_replace(self.__private.map, card_obj, prev + count);
        } else {
            ds_map_add(self.__private.map, card_obj, c);
        }
    };

    /// Remove up to `count` copies from the deck. Returns number removed.
    /** @param {Asset.GMObject} card_obj */
    /** @param {real} count */
    static remove = function(card_obj, count = 1) {
        if (!ds_map_exists(self.__private.map, card_obj)) {
            return;
        }
        
        var curr_count = ds_map_find_value(self.__private.map, card_obj);
        var remaining = curr_count - count;
        if (remaining > 0) {
            ds_map_replace(self.__private.map, card_obj, remaining);
        } else {
            ds_map_delete(self.__private.map, card_obj);
        }
    };

    /// Get the number of copies owned of a given card object.
    /** @param {Asset.GMObject} card_obj */
    /** @return {real} count */
    static count = function(card_obj) {
        if (!ds_map_exists(self.__private.map, card_obj)) return 0;
        return ds_map_find_value(self.__private.map, card_obj);
    };

    /// Total number of card copies in the deck (sum of counts).
    /** @return {real} total count */
    static total_cards = function() {
        var total = 0;
        var key = ds_map_find_first(self.__private.map);
        while (!is_undefined(key)) {
            var v = ds_map_find_value(self.__private.map, key);
            total += v;
            key = ds_map_find_next(self.__private.map, key);
        }
        
        return total;
    };
    
    static for_each = function(action) {
        for_each_entry_in_map(self.__private.map, action);
    }

    /// Clear the map (remove all owned entries).
    static clear = function() {
        ds_map_clear(self.__private.map);
    };

    /// Destroy the map entirely (call when discarding deck).
    static destroy = function() {
        if (ds_exists(self.__private.map, ds_type_map)) {
            ds_map_destroy(self.__private.map);
            self.__private.map = undefined;
        }
    };
}
