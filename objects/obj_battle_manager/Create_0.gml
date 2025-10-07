enemy = undefined;
player = undefined;

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
    var n = instance_number(obj_card_drop_area);
    var enemy_cards = [];
    var player_cards = [];
    for (var i = 0; i < n; i += 1) {
        var drop_area = instance_find(obj_card_drop_area, i);
        switch (drop_area.owner) {
        	case "Player":
                player_cards[array_length(player_cards)] = drop_area.card;
                break;
            case "Enemy":
                enemy_cards[array_length(enemy_cards)] = drop_area.card;
                break;
        }
    }
    
    var i = 0;
    while (i < min(array_length(player_cards), array_length(enemy_cards))) {
        var player_card = player_cards[i];
        if (player_card != noone) {
            player_card.card_data.apply(self.player, self.enemy);
            self.discard_pile.add(player_card);
        }
        
        var enemy_card = enemy_cards[i];
        if (enemy_card != noone) {
            enemy_card.card_data.apply(self.enemy, self.player);
        }
        
        i += 1;
    }
    
    while (i < array_length(player_cards)) {
        var player_card = player_cards[i];
        if (player_card != noone) {
            player_card.card_data.apply(self.player, self.enemy);
            self.discard_pile.add(player_card);
        }
        
        i += 1;
    }
    
    while (i < array_length(enemy_cards)) {
        var enemy_card = enemy_cards[i];
        if (enemy_card != noone) {
            enemy_card.card_data.apply(self, self.player);
        }
        
        i += 1;
    }
    
    transfer_between_piles(self.hand, self.discard_pile);
}

end_battle = function() {
    self.draw_pile.clear();
    self.discard_pile.clear();
    self.hand.clear()
}