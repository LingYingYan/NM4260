deck = new Deck();
self.deck.add(obj_card_item, 20);
draw_pile = new CardPile();                 
discard_pile = new CardPile();                
hand = new Hand(self.hand_capacity); 

/// @desc Spawn a card
/// @param {id.instance} card A card to spawn
add_to_hand = function(card) {
    self.hand.insert(card, self.hand.size() - 1);
    half_width = self.hand.size() % 2 == 0
        ? (self.hand.size() / 2 - 1) * self.spacing + self.spacing / 2
        : self.hand.size() / 2 * self.spacing;
    start_x = self.x - half_width;
    for (i = 0; i < self.hand.size(); i += 1) {
        c = self.hand.get(i);
        c.x = start_x + i * self.spacing;
        c.y = self.y;
    }
}

start_turn = function() {
    while (self.hand.size() < self.hand_capacity) {
        if (self.draw_pile.is_empty()) {
            if (self.discard_pile.is_empty()) {
                break;
            }
            
            while (!self.discard_pile.is_empty()) {
                self.draw_pile.insert(self.discard_pile.draw());        
            }   
        }
        
        var card = self.draw_pile.draw();
        self.add_to_hand(card);
    }
};

end_turn = function() {
    for (var i = self.hand.size() - 1; i >= 0; i -= 1) {
        self.discard_pile.insert(self.hand.get(i));
    }
    
    self.hand.clear();
};

start_battle = function() {
    var pile = self.draw_pile;
    self.deck.for_each(method({ pile: pile }, function(card, count) {
        for (i = 0; i < count; i += 1) {
            pile.insert(card);    
        }    
    }));
}

end_battle = function() {
    self.hand.clear();
    self.draw_pile.clear();
    self.discard_pile.clear();
}

obtain_card = function(card, count = 1) {
    self.deck.add(card, count);
}
