draw_pile = obj_draw_pile;
discard_pile = obj_discard_pile;
deck = obj_card_pile;
hand = obj_hand;

start_battle = function() {
    transfer_between_piles(self.deck, self.draw_pile);
}

start_player_turn = function() {
    repeat(5) {
        var card = self.draw_pile.draw();
        if (card == noone) {
            break;
        }
        
        self.hand.add(card);
    }
}

draw = function() {
    if (self.draw_pile.is_empty()) {
        transfer_between_piles(self.discard_pile, self.draw_pile);
        self.draw_pile.shuffle();
    }
    
    return self.draw_pile.draw();
}

end_player_turn = function() {
    transfer_between_piles(self.hand, self.discard_pile);
}

end_battle = function() {
    self.draw_pile.clear();
    self.discard_pile.clear();
    self.hand.clear()
}