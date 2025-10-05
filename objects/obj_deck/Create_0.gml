cards = ds_map_create()

/// @desc Add a card to deck\=
/// @param {id.Instance} card A card
add = function(card) {
    if (!ds_map_exists(self.cards, card)) {
        ds_map_add(self.cards, card, 1);
    } else {
        self.cards[? card] += 1;
    }
}

/// @desc Remove a card from deck
/// @param {id.instance} card A card
remove = function(card) {
    if (!ds_map_exists(self.cards, card)) {
        return;
    }
    
    self.cards[? card] -= 1;
    if (self.cards[? card] == 0) {
        ds_map_delete(self.cards, card);
    }
}

fill_deck = function(pile) {
    var card = ds_map_find_first(self.cards);
    while (card != undefined) {
        repeat (self.cards[? card]) {
            pile.add(card)        	
        }
    }
}