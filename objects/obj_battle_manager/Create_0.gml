enemy = obj_enemy;
player = obj_player_state;

draw_pile = obj_draw_pile;
discard_pile = obj_discard_pile;
deck = obj_card_pile;
hand = obj_hand;

enemy_card_slots = [];
player_card_slots = [];

max_turn_pointer = 0;
turn_pointer = 0; 
can_resolve_card = false;
enemy_cards = []; 
player_cards = [];

turn_timer = undefined;

resolve_turn = function() { 
    self.can_resolve_card = false;
    self.turn_pointer = 0;
    self.max_turn_pointer = 0;
    self.enemy_cards = [];
    self.player_cards = [];
    transfer_between_piles(self.hand, self.discard_pile, 0, false);
    if (self.player.data.hp <= 0) {
        self.enemy_win();
    } else if (self.enemy.data.hp <= 0) {
        self.player_win();
    } else {
        self.start_player_turn();
    }
}

enemy_win = function() {
    obj_player_deck_manager.clear();
    obj_room_manager.goto_deck_selection();
}

player_win = function() {
    self.player.data.clear_marks_and_statuses();
    self.player.data.vision += 1;
    self.player.data.vision = min(self.player.data.vision, self.player.max_vision);
    self.end_battle();

    obj_backdrop.visible = true;
    // Create new cards to pick
    instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_card_loot);
}

start_battle = function() {
    // Close UI
    obj_loot_panel.visible = false;
    
    // Initialise player
    obj_player_state.data.clear_marks_and_statuses();
    obj_player_state.initialise();
    
    // Set up card slots
    var n = instance_number(obj_card_drop_area);
    for (var i = 0; i < n; i += 1) {
        var drop_area = instance_find(obj_card_drop_area, i);
        switch (drop_area.owner) {
        	case "Player":
                self.player_card_slots[array_length(self.player_card_slots)] = drop_area;
                break;
            case "Enemy":
                self.enemy_card_slots[array_length(self.enemy_card_slots)] = drop_area;
                break;
        }
    }
    
    // Set up player draw pile
    transfer_between_piles(self.deck, self.draw_pile, 0, false);
    self.draw_pile.shuffle();
    
    // Load enemy
    var enemy = res_loader_enemies.get_random_enemy("Characters", room_width / 2, 0);
    self.enemy.data = enemy.data;
    self.enemy.data.clear_marks_and_statuses();
    instance_destroy(enemy);
    self.enemy.initialise();
    
    // START!
    self.start_player_turn();
}

start_player_turn = function() {
    obj_end_turn_button.is_disabled = false;
    
    // Update modifiers and status effects
    self.enemy.data.reset_modifiers();
    self.enemy.data.execute_status_effects();
    self.player.data.reset_modifiers();
    self.player.data.execute_status_effects();
    
    // If anyone dies, end the battle here
    if (self.player.data.hp <= 0) {
        self.resolve_turn();
        return;
    }
    
    if (self.enemy.data.hp <= 0) {
        self.resolve_turn();
        return;
    }
    
    // Set up deck and card slots
    self.enemy.reset_deck();
    for (var i = 0; i < array_length(self.player_card_slots); i += 1) {
        if (instance_exists(self.player_card_slots[i].card)) {
            self.player_card_slots[i].card.dropped_area = noone;
        }
        
        self.player_card_slots[i].card = noone;
    }
    
    for (var i = 0; i < array_length(self.enemy_card_slots); i += 1) {
        if (instance_exists(self.enemy_card_slots[i].card)) {
            self.enemy_card_slots[i].card.dropped_area = noone;
            instance_destroy(self.enemy_card_slots[i].card);
        }
        
        self.enemy_card_slots[i].card = noone;
    }
    
    // Freeze card slots
    for (var i = 0; i < array_length(self.player_card_slots); i += 1) {
        self.player_card_slots[i].is_disabled = i >= array_length(self.player_card_slots) - self.player.data.modifiers.frozen_slots;
    }
    
    for (var i = 0; i < array_length(self.enemy_card_slots); i += 1) {
        self.enemy_card_slots[i].is_disabled = i >= array_length(self.enemy_card_slots) - self.enemy.data.modifiers.frozen_slots;
    }
    
    // Enemy plays
    for (var i = 0; i < array_length(self.enemy_card_slots) - self.enemy.data.modifiers.frozen_slots; i += 1) {
        var card = self.enemy.play_card();
        card.image_xscale = self.enemy_card_slots[i].image_xscale;
        card.image_yscale = self.enemy_card_slots[i].image_yscale;
        card.scale = self.enemy_card_slots[i].image_xscale;
        place_card(card, self.enemy_card_slots[i].x, self.enemy_card_slots[i].y);
        enemy_card_slots[i].card = card;
    }
    
    // Player draws
    repeat(5) {
        var card = self.draw();
        if (card == noone) {
            break;
        }
        
        self.hand.add(card.id);
    }
}

draw = function() {
    if (self.draw_pile.is_empty()) {
        transfer_between_piles(self.discard_pile, self.draw_pile, 0, false);
        self.draw_pile.shuffle();
    }
    
    var card = self.draw_pile.draw();
    if (instance_exists(card)) {
        card.set_reveal(self.player.max_vision, self.player.data, self.enemy.data);
        card.grabbable = true;  
        card.scale = self.player_card_slots[0].image_xscale;
    }
    
    return card;
}

/**
 * @desc  
 * @param {id.instance} player_card description
 * @param {id.instance} enemy_card description    
 */
flip_cards = function(player_card, enemy_card) {
    if (player_card != noone) {
        player_card.state_update = player_card.state_flip;
    }
    
    if (enemy_card != noone) {
        enemy_card.state_update = enemy_card.state_flip;
    }
    
    time_source_destroy(self.turn_timer);
    self.turn_timer = time_source_create(
        time_source_game, 2, time_source_units_seconds, 
        execute_player_card, [player_card, enemy_card]
    );
    
    time_source_start(self.turn_timer);
}

execute_player_card = function(player_card, enemy_card) {
    if (player_card != noone) {
        player_card.card_data.apply(self.player.data, self.enemy.data);
    }
    
    time_source_destroy(self.turn_timer);
    self.turn_timer = time_source_create(
        time_source_game, 0.25, time_source_units_seconds, 
        recycle_player_card, [player_card, enemy_card]
    );
        
    time_source_start(self.turn_timer);
}

recycle_player_card = function(player_card, enemy_card) {
    if (instance_exists(player_card)) {
        player_card.card_data.is_nullified = false;
        self.discard_pile.add(player_card);
        player_card.image_xscale = player_card.scale;
        player_card.image_yscale = player_card.scale;
        player_card.grabbable = false; 
        player_card.set_reveal(0);
    }
    
    self.player_cards[self.turn_pointer] = noone;
    if (self.enemy.data.hp <= 0 || self.player.data.hp <= 0) {
        self.resolve_turn();
        return;
    }
    
    time_source_destroy(self.turn_timer);
    self.turn_timer = time_source_create(
        time_source_game, 0.5, time_source_units_seconds, 
        execute_enemy_card, [enemy_card]
    );
        
    time_source_start(self.turn_timer);
}

execute_enemy_card = function(enemy_card) {
    if (enemy_card != noone) {
        enemy_card.card_data.apply(self.enemy.data, self.player.data);
    }
    
    time_source_destroy(self.turn_timer);
    self.turn_timer = time_source_create(
        time_source_game, 0.25, time_source_units_seconds, 
        recycle_enemy_card, [enemy_card]
    );
        
    time_source_start(self.turn_timer);
}

recycle_enemy_card = function(enemy_card) {
    time_source_destroy(self.turn_timer);
    if (instance_exists(enemy_card)) { 
        enemy_card.card_data.is_nullified = false;
        place_card(enemy_card, self.enemy.x, -500);
    }
    
    self.enemy_cards[self.turn_pointer] = noone;
    if (self.enemy.data.hp <= 0 || self.player.data.hp <= 0) {
        self.resolve_turn();
        return;
    }
    
    self.turn_pointer += 1;
    if (self.turn_pointer == self.max_turn_pointer) {
        self.resolve_turn();
    } else {
        self.can_resolve_card = true;
    }
}

end_player_turn = function() {
    obj_end_turn_button.is_disabled = true;
    
    self.enemy.data.update_status_effects();
    self.player.data.update_status_effects();
    
    self.turn_pointer = 0;
    
    // Collect both sides' cards
    for (var i = 0; i < array_length(self.player_card_slots); i += 1) {
        self.player_cards[i] = self.player_card_slots[i].card;
    }
    
    for (var i = 0; i < array_length(self.enemy_card_slots); i += 1) {
        self.enemy_cards[i] = self.enemy_card_slots[i].card;
    }
    
    self.max_turn_pointer = max(array_length(self.player_cards), array_length(self.enemy_cards));
    self.can_resolve_card = true;
}

end_battle = function() {
    array_foreach(self.player_cards, function(card) {
        if (card != noone) {
            instance_destroy(card.id);
        }    
    })
    
    instance_destroy(obj_enemy_card);
    self.player_card_slots = [];
    self.enemy_card_slots = [];
    self.can_resolve_card = false;
    self.turn_pointer = 0;
    self.max_turn_pointer = 0;
    self.enemy_cards = [];
    self.player_cards = [];
    transfer_between_piles(self.hand, self.discard_pile, 0, false);
}

// Placeholder functions for card animations
reveal_cards = function() {
    if (self.turn_pointer >= array_length(self.enemy_cards)) {
        return;
    }
}

state_update = function() { }