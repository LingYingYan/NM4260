/// ---------------------------------------------------------------------------
/// hand constructor
/// A hand with capacity. Supports insertion by index, removal by value,
/// and a draw_on_top(card) method which snaps a card's depth above all others.
/// ---------------------------------------------------------------------------
/** @param {real} _capacity  Maximum number of cards allowed in the hand (int) */
function Hand(_capacity) constructor {
    __private = { 
        list: ds_list_create(), 
        capacity: max(0, _capacity)
    }
    
    static contains = function(card) {
        return ds_list_find_index(self.__private.list, card) != -1;
    }
    
    /// @desc Checks if the hand is full
    /** @return {bool} True if the hand is full */
    static is_full = function() {
        return ds_list_size(self.__private.list) >= self.__private.capacity;
    }
    
    /// Get current size of the hand.
    /** @return {real} The hand size */
    static size = function() {
        return ds_list_size(self.__private.list);
    };
    
    /// @desc Insert card into hand at index (0..size). Returns true on success, false if full.
    /** @param {id.instance} card       The card to insert. */
    /** @param {real} index   Integer insertion index (0 inserts at front, size appends). */
    /** @return {bool} True if the insertion is successful */
    static insert = function(card, index) {
        if (self.is_full()) {
            // hand is full
            return false;
        }
    
        // clamp index
        var idx = clamp(index, 0, self.size());
    
        // insertion by shifting: append then rotate portion to emulate insert
        ds_list_insert(self.__private.list, idx, card); // now size+1
        return true;
    };
    
    /// Remove a card from the hand (first occurrence) and return true if removed.
    /** @param {id.instance} card Card to remove (compared by identity/value) */
    static remove = function(card) {
        var idx = ds_list_find_index(self.__private.list, card);
        if (idx == -1) {
             return false;
        }
        
        ds_list_delete(self.__private.list, idx);
        return true;
    };
    
    
    
    /// Get the card at index (or undefined if out of range).
    /** @param {real} index */
    static get = function(index) {
        if (index < 0 || index >= self.size()) {
            return undefined;
        }
        
        return ds_list_find_value(self.__private.list, index);
    };
    
    /// Snap the provided card (which must be inside the hand) to a depth value higher
    /// than every other card currently in the hand. This simply sets:
    ///     card.depth = current_max_depth + 1
    /// If the card is not found in the hand, this function returns false.
    /** @param {id.instance<obj_card_item>} card       The card instance inside the hand to bring on top. */
    static draw_on_top = function(card) {
        // confirm the card exists in hand
        var idx = ds_list_find_index(self.__private.list, card);
        if (idx == -1) {
            return;
        }
    
        var min_depth = 99999;
        for (var i = 0; i < self.size(); i += 1) {
            var c = ds_list_find_value(self.__private.list, i);
            if (!is_undefined(c) && c.depth < min_depth) {
                min_depth = c.depth;
            }
        }
        
        if (card.depth == min_depth) {
            return;
        }
    
        card.depth = min_depth - 1;
    };
    
    /// Clear the hand.
    static clear = function() {
        ds_list_clear(self.__private.list);
    };
    
    /// Destroy the hand's internal DS structures.
    static destroy = function() {
        if (is_undefined(self) || is_undefined(self.__private)) {
            return;
        }
        
        if (ds_exists(self.__private.list, ds_type_list)) {
            ds_list_destroy(self.__private.list);
            self.__private.list = undefined;
        }
    };
}
