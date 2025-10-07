card_piles = [];

var n = instance_number(obj_initial_card_pile);
for (var i = 0; i < n; i += 1) {
    card_piles[i] = instance_find(obj_initial_card_pile, i);
}

pick = function(card_id) {
    self.find_deck(card_id).remove(card_id);
    obj_hand.add(card_id);
}

find_deck = function(card_id) {
    for (var i = 0; i < array_length(self.card_piles); i += 1) {
        if (self.card_piles[i].card.name == card_id.card_data.name) {
            return self.card_piles[i];
        }
    }
    
    return noone;
}

put_back = function(card_id) {
    obj_hand.remove(card_id);
    self.find_deck(card_id).add(card_id);
}