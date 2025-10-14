cards = ds_list_create();

size = function() {
    return ds_list_size(self.cards);
}

add = function(card) {
    ds_list_add(self.cards, card);
    place_card(card, self.x, self.y);
    if (ds_list_size(self.cards) == 1) {
        card.depth = -1000;
    } else {
        card.depth = self.cards[| ds_list_size(self.cards) - 1].depth - 1;
    }
}

shuffle = function() {
    ds_list_shuffle(self.cards);
}

is_empty = function() {
    return ds_list_size(self.cards) == 0;
}

remove = function(card) {
    ds_list_delete(self.cards, ds_list_find_index(self.cards, card));
}

/**
 * @desc 
 * @return {id.instance} description
 */
draw = function() {
    if (self.is_empty()) {
        return noone;
    }
    
    var card = self.cards[| self.size() - 1];
    self.remove(card);
    return card;
}

clear = function() {
    a = [];
    for (var i = 0; i < ds_list_size(self.cards); i += 1) {
        a[i] = self.cards[| i];
    }
    
    ds_list_clear(self.cards);
    return a;
}