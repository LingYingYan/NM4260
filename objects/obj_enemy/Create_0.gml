// Inherit the parent event
event_inherited();

indicators_y = self.bbox_bottom;

played_cards = [];
available_cards = [];
cooldown_cards = [];
brain = new UtilityAgent();

initialise = function() { 
    self.status_indicators = [];
    self.mark_indicators = [];
    var health_bar = instance_create_depth(self.x, self.bbox_bottom, self.depth - 1, obj_ui_health_bar);
    health_bar.label_below_bar = true;
    health_bar.source = data;
}

draw = function(k) {
    array_shuffle_ext(self.data.cards);
    k = min(k, array_length(self.data.cards));
    self.available_cards = [];
    repeat (k) {
        var card = self.data.draw();
        show_debug_message($"Draw {card.name}, {array_length(self.data.cards)} remaining");
    	array_push(self.available_cards, card);
    }
}

plan_and_decide = function(k) {
    self.brain.refresh();
    var options = permutations(self.available_cards, k);
    show_debug_message($"{array_length(options)} permutations are generated");
    for (var i = 0; i < array_length(options); i += 1) {
        var cards = options[i];
        make_action_balanced(self, cards, self.brain, obj_player_state.data);
    }
    
    var action = self.brain.make_decision({ });
    return self.play(action.cards);
}

play = function(cards) {
    var instances = [];
    for (var i = 0; i < array_length(cards); i += 1) {
        // Create the card instance
        var card = instance_create_layer(self.x, -500, "Cards", obj_enemy_card);
        card.card_data = cards[i];
        
        // Randomly reveal the card
        card.owner = self.data;
        card.opponent = obj_player_state.data;
        card.reveal = random_range(0, obj_battle_manager.player.data.vision);
        card.can_reveal = true;
        
        array_push(instances, card);
    }
    
    return instances;
}