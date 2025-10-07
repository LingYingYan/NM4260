enemy = undefined;
player = obj_battle_player;

draw_pile = obj_draw_pile;
discard_pile = obj_discard_pile;
deck = obj_card_pile;
hand = obj_hand;

start_battle = function() {
    transfer_between_piles(self.deck, self.draw_pile, 0, false);
    self.draw_pile.shuffle();
    //var ac_channel = animcurve_get_channel(ac_enemy_weight_distance_coefficient, "coefficient");
    //var k = animcurve_channel_evaluate(ac_channel, )
    self.enemy = res_loader_enemies.get_random_enemy("Characters", room_width / 2, 0);
    self.start_player_turn();
}

start_player_turn = function() {
    repeat(5) {
        var card = self.draw_pile.draw();
        if (card == noone) {
            break;
        }
        
        card.reveal = 100;
        card.grabbable = true;
        self.hand.add(card);
    }
    
    layer_set_visible("BattleScreen", true);
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
            player_card.card_data.apply(self.player.data, self.enemy.data);
            self.discard_pile.add(player_card);
        }
        
        var enemy_card = enemy_cards[i];
        if (enemy_card != noone) {
            enemy_card.card_data.apply(self.enemy.data, self.player.data);
        }
        
        i += 1;
    }
    
    while (i < array_length(player_cards)) {
        var player_card = player_cards[i];
        if (player_card != noone) {
            player_card.card_data.apply(self.player.data, self.enemy.data);
            self.discard_pile.add(player_card);
        }
        
        i += 1;
    }
    
    while (i < array_length(enemy_cards)) {
        var enemy_card = enemy_cards[i];
        if (enemy_card != noone) {
            enemy_card.card_data.apply(self.enemy.data, self.player.data);
        }
        
        i += 1;
    }
    
    transfer_between_piles(self.hand, self.discard_pile);
}

end_battle = function() {
    self.draw_pile.clear();
    self.discard_pile.clear();
    self.hand.clear();
    self.enemy = undefined;
    self.player = undefined;
    obj_room_manager.goto_map();
}