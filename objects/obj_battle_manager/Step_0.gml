if (!self.can_resolve_card) {
    exit;
}

var idx = floor(self.turn_pointer / 2);
if (self.turn_pointer % 2 == 0) {
    // Player's card
    var card = self.player_cards[idx];
    if (card == noone) {
        self.turn_pointer += 1;
    } else {
        self.can_resolve_card = false;
        self.turn_timer = time_source_create(
            time_source_game, 1, time_source_units_seconds, 
            execute_player_card, [card]
        );
        
        time_source_start(self.turn_timer);
    }
} else {
    // Enemy's card
    var card = self.enemy_cards[idx];
    if (card == noone) {
        self.turn_pointer += 1;
    } else {
        self.can_resolve_card = false;
        self.turn_timer = time_source_create(
            time_source_game, 1, time_source_units_seconds, 
            execute_enemy_card, [card]
        );
        
        time_source_start(self.turn_timer);
    }
}