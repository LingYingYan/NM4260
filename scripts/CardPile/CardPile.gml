/// ---------------------------------------------------------------------------
/// card_pile constructor
/// A simple draw/discard pile struct. Uses an internal ds_list to hold cards.
/// Methods are attached as static functions of the constructor so you call:
///    var pile = card_pile();
///    card_pile.insert(pile, some_card);
/// ---------------------------------------------------------------------------
function CardPile() constructor {
    __private = { 
        list: ds_list_create()
    }
    
    static size = function() {
        return ds_list_size(self.__private.list);
    }
    
    static is_empty = function() {
        return self.size() == 0;
    }

    /// @desc Insert a card into the pile (push to the end).
    /** @param {id.instance} card A card */
    static insert = function(card) {
        ds_list_add(self.__private.list, card);
        return true;
    };
    
    /// @desc Remove a single occurrence of a card from the pile. Returns true if removed.
    /** @param {id.instance} card Card to remove (compared by identity/value) */
    static remove = function(card) {
        var idx = ds_list_find_index(self.__private.list, card);
        if (idx != -1) {
            ds_list_delete(self.__private.list, idx);
            return true;
        }
        
        return false;
    };
    
    /// @desc Shuffle the pile in-place using Fisher-Yates.
    static shuffle = function() {
        ds_list_shuffle(self.__private.list)
    };
    
    /// @desc Draw (remove + return) the top card of the pile.
    /// By convention this returns the last item in the internal list.
    /// @return {id.instance} The card drawn
    static draw = function() {
        var idx = irandom_range(0, ds_list_size(self.__private.list) - 1);
        var card = ds_list_find_value(self.__private.list, idx);
        ds_list_delete(list, idx);
        return card;
    };
    
    /// @desc Peek the top card without removing.
    static peek = function() {
        var list = self.__private.list;
        var n = ds_list_size(list);
        if (n <= 0) {
            return undefined;
        }
        
        return ds_list_find_value(list, n - 1);
    };
    
    /// @desc Clear the pile.
    static clear = function() {
        ds_list_clear(self.__private.list);
    };
    
    /// @desc Destroy the internal ds_list. Call when you no longer need the pile.
    static destroy = function() {
        if (is_undefined(self) || is_undefined(self.__private)) {
            return;
        }
        
        if (ds_exists(self.__private.list, ds_type_list)) {
            ds_list_destroy(self.__private.list);
            self.__private.list = noone;
        }
    };
}
