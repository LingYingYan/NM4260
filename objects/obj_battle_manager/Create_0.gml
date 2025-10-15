enemy = undefined;
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
    show_debug_message("Player win!");
    self.player.data.clear_marks_and_statuses();
    self.player.data.vision += 1;
    self.end_battle();
    obj_loot_panel.visible = true;
    
    // Create the button to pick a new card
    var card_option = instance_create_layer(0, 0, "Instances", obj_option_button);
    card_option.button_text = "New Card!";
    obj_loot_panel.add_item(card_option);
    
    // On click, collect a card and remove the button
    // Bruh so much work just to curry one variable...
    card_option.on_click = method({this: card_option}, function() {
        obj_loot_panel.hide();
        var selected = [];
        for (var i = 0; i < 3; i += 1) {
        	var random_card = res_loader_cards.get_random_card("Cards");
            if (array_contains(selected, random_card.card_data.uid)) {
                while (array_contains(selected, random_card.card_data.uid)) {
                    instance_destroy(random_card);
                    random_card = res_loader_cards.get_random_card("Cards");
                } 
            }
            
            var card_x = room_width / 2 + (i - 1) * 2 * random_card.sprite_width;
            var new_card = instance_create_layer(card_x, room_height / 2, "Cards", obj_pickup_card);
            new_card.card_data = random_card.card_data;
            new_card.image_xscale = 1.5;
            new_card.image_yscale = 1.5;
            new_card.set_reveal(obj_player_state.data.max_vision);
            new_card.on_click = method({source: this}, function() {
                obj_loot_panel.remove_item(source);
                obj_loot_panel.show();
            });
        }
    });
    
    // Create the button to go back to map
    var exit_option = instance_create_layer(0, 0, "Instances", obj_option_button);
    exit_option.button_text = "Finish Battle";
    obj_loot_panel.add_item(exit_option);
    exit_option.on_click = function() {
        show_debug_message($"HP: {self.player.data.hp}");
        obj_room_manager.goto_map();
    }
    
    
    global.pause = true;
}

start_battle = function() {
    obj_loot_panel.visible = false;
    obj_player_state.data.clear_marks_and_statuses();
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
    
    transfer_between_piles(self.deck, self.draw_pile, 0, false);
    self.draw_pile.shuffle();
    //var ac_channel = animcurve_get_channel(ac_enemy_weight_distance_coefficient, "coefficient");
    //var k = animcurve_channel_evaluate(ac_channel, )
    self.enemy = res_loader_enemies.get_random_enemy("Characters", room_width / 2, 0);
    self.enemy.data.clear_marks_and_statuses();
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
    
    // Enemy plays
    for (var i = 0; i < array_length(self.enemy_card_slots); i += 1) {
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
        card.set_reveal(self.player.max_vision);
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
        execute_cards, [player_card, enemy_card]
    );
    
    time_source_start(self.turn_timer);
}

/**
 * @desc 
 * @param {id.instance} player_card description
 * @param {id.instance} enemy_card description    
 */
execute_cards = function(player_card, enemy_card) {
    var player_card_data = player_card == noone ? noone : player_card.card_data;
    var enemy_card_data = enemy_card == noone ? noone : enemy_card.card_data;
    apply_special_effects(self.player.data, player_card_data, self.enemy.data, enemy_card_data);
    
    if (player_card != noone) {
        player_card.card_data.apply(self.player.data, self.enemy.data);
    }
    
    if (enemy_card != noone) {
        enemy_card.card_data.apply(self.enemy.data, self.player.data);
    }
    
    time_source_destroy(self.turn_timer);
    self.turn_timer = time_source_create(
        time_source_game, 1, time_source_units_seconds, 
        recycle_cards, [player_card, enemy_card]
    );
    
    time_source_start(self.turn_timer);
}

recycle_cards = function(player_card, enemy_card) {
    time_source_destroy(self.turn_timer);
    if (instance_exists(player_card)) {
        player_card.card_data.is_nullified = false;
        self.discard_pile.add(player_card);
        player_card.image_xscale = player_card.scale;
        player_card.image_yscale = player_card.scale;
        player_card.grabbable = false; 
        player_card.set_reveal(0);
    }
    
    if (instance_exists(enemy_card)) { 
        enemy_card.card_data.is_nullified = false;
        place_card(enemy_card, self.enemy.x, -500);
        instance_destroy(enemy_card);
    }
    
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