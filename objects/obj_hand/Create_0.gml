cards = ds_list_create();

size = function() {
    return ds_list_size(self.cards);
}

/// @desc Add a card
/// @param {id.instance} card The card
add = function(card) {
    if (ds_list_find_index(self.cards, card) == -1) {
        ds_list_add(self.cards, card);
        show_debug_message($"Added: {card}");
    }
    
    rearrange_hand(self, ds_list_size(self.cards), self.spacing, self.cards);
}

is_empty = function() {
    return ds_list_size(self.cards) == 0;
}

/// @desc Remove a card
/// @param {id.instance} card The card
remove = function(card) {
    var idx = ds_list_find_index(self.cards, card);
    if (idx == -1) {
        return;
    }
    
    var c = self.cards[| idx];
    ds_list_delete(self.cards, idx);
    rearrange_hand(self, ds_list_size(self.cards), self.spacing, self.cards);
    return c;
}

clear = function() {
    var a = [];
    for (var i = 0; i < ds_list_size(self.cards); i += 1) {
        a[i] = self.cards[| i];
    }
    
    ds_list_clear(self.cards);
    return a;
}
