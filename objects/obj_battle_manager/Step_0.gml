// Execute the cards
if (!self.can_resolve_card) {
    exit;
}

var idx = self.turn_pointer;
var player_card = idx < array_length(self.player_cards) 
    ? self.player_cards[idx]
    : noone;
var enemy_card = idx < array_length(self.enemy_cards)
    ? self.enemy_cards[idx]
    : noone;
if (player_card == noone && enemy_card == noone) {
    self.turn_pointer += 1;
} else {
    self.can_resolve_card = false;
    enemy_card.set_reveal(self.player.max_vision);
    self.turn_timer = time_source_create(
        time_source_game, 1, time_source_units_seconds, 
        execute_cards, [player_card, enemy_card]
    );
        
    time_source_start(self.turn_timer);
}
