// Inherit the parent event
event_inherited();

indicators_y = self.bbox_bottom;

played_cards = [];

initialise = function() { 
    var health_bar = instance_create_depth(self.x, self.bbox_bottom, self.depth - 1, obj_ui_health_bar);
    health_bar.label_below_bar = true;
    health_bar.source = data;
}

play_card = function() {
    // Remove a random card from the deck
    var idx = irandom_range(0, array_length(self.data.cards) - 1);
    var card_data = self.data.cards[idx];
    self.played_cards[array_length(self.played_cards)] = card_data;
    array_delete(self.data.cards, idx, 1);
    
    // Create the card instance
    var card = instance_create_layer(self.x, -500, "Cards", obj_enemy_card);
    card.card_data = card_data;
    
    // Randomly reveal the card
    card.set_reveal(random_range(0, obj_battle_manager.player.data.vision), self.data, obj_battle_manager.player.data);
    card.can_reveal = true;
    
    return card;
}

reset_deck = function() {
    for (var i = 0; i < array_length(self.played_cards); i += 1) {
        self.data.cards[array_length(self.data.cards)] = self.played_cards[i];
    }
    
    self.played_cards = [];
}