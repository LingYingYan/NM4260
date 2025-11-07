cards = [];

size = function() {
    return array_length(self.cards);
}

add = function(card) {
    place_card(card, self.x, self.y);
    if (self.size() == 0) {
        set_card_depth(card, self.depth - 1);
        show_debug_message($"Card {card} depth: {card.normal_depth}");
    } else {
        set_card_depth(card, array_last(self.cards).normal_depth - 1);
        show_debug_message($"last card {array_last(self.cards)} depth: {array_last(self.cards).normal_depth}")
        show_debug_message($"Card {card} depth: {card.normal_depth}");
    }
    
    array_push(self.cards, card);
}

shuffle = function() {
    array_shuffle(self.cards);
}

is_empty = function() {
    return self.size() == 0;
}

remove = function(card) {
    var idx = array_get_index(self.cards, card);
    if (idx < 0) {
        show_error($"Card {card} not found in {self}", true);
        return;    
    }
    
    array_delete(self.cards, idx, 1);
}

/**
 * @desc 
 * @return {id.instance} description
 */
draw = function() {
    if (self.is_empty()) {
        return noone;
    }
    
    return array_pop(self.cards);
}

clear = function() {
    var copy = [];
    array_copy(copy, 0, self.cards, 0, self.size());
    self.cards = [];
    return copy;
}