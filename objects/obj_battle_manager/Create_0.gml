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
enemy_cards = []; 
player_cards = [];

turn_timer = undefined;

get_player_card = function() {
    return self.turn_pointer < array_length(self.player_cards) 
        ? self.player_cards[self.turn_pointer]
        : noone;
}

get_enemy_card = function() {
    return self.turn_pointer < array_length(self.enemy_cards) 
        ? self.enemy_cards[self.turn_pointer]
        : noone;
}

resolve_turn = function() { 
    with (obj_card) {
        state_update = state_normal;
    }
    
    time_source_destroy(self.turn_timer);
    self.turn_pointer = 0;
    self.max_turn_pointer = 0;
    self.enemy_cards = [];
    self.player_cards = [];
    transfer_between_piles(self.hand, self.discard_pile, 0, false);
    if (!self.attempt_to_end_battle()) {
        self.start_player_turn();
    }
}

enemy_win = function() {
    self.end_battle();
    obj_player_deck_manager.clear();
    obj_backdrop.visible = true;
    // Pick traits
    instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_death_panel);
    // obj_room_manager.goto_deck_selection();
}

player_win = function() {
    self.player.data.clear_marks_and_statuses();
    self.player.data.vision += 1;
    self.player.data.vision = min(self.player.data.vision, self.player.max_vision);
    self.end_battle();

    obj_backdrop.visible = true;
    // Create new cards to pick
    global.has_relic = irandom_range(1, 100) <= 100;
    global.has_trait = irandom_range(1, 100) <= 100;
    instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_card_loot);
    
    global.number_of_completed_combat += 1;
    self.player.data.remove_expired_relics();
}

start_battle = function() {
    // Close UI
    obj_loot_panel.visible = false;
    obj_backdrop.depth = obj_player_state.depth - 100;
    
    // Initialise player
    obj_player_state.initialise();
    
    // Set up card slots
    find_card_slots(self.player_card_slots, self.enemy_card_slots);
    
    // Set up player draw pile
    transfer_between_piles(self.deck, self.draw_pile, 0, false);
    self.draw_pile.shuffle();
    
    // Load enemy
    self.enemy.data = global.is_tut
        ? res_loader_enemies.get_enemy_by_id("enemy_cultist")
        : (global.boss_fight ? res_loader_enemies.get_random_boss() : res_loader_enemies.get_random_enemy());
    self.enemy.initialise();
    
    // START!
    self.start_player_turn();
}

attempt_to_end_battle = function() {
    if (self.player.data.hp <= 0) {
        if (!is_undefined(self.turn_timer) && time_source_exists(self.turn_timer)) {
            time_source_destroy(self.turn_timer);
        }
        
        self.enemy_win();
        return true;
    }
        
    if (self.enemy.data.hp <= 0) {
        if (!is_undefined(self.turn_timer) && time_source_exists(self.turn_timer)) {
            time_source_destroy(self.turn_timer);
        }
        
        self.player_win();
        return true;
    }
    
    return false;
}

start_player_turn = function() {
    // Set up deck and card slots
    reset_card_slots(self.player_card_slots, self.enemy_card_slots);

    // If anyone dies, end the battle here
    if (self.attempt_to_end_battle()) {
        return;
    }
    
    // Freeze card slots
    for (var i = 0; i < array_length(self.player_card_slots); i += 1) {
        self.player_card_slots[i].is_disabled = self.player.data.get_attribute("frozen") && 
                                                (i == 0 || i == array_length(self.player_card_slots) - 1);
    }

    for (var i = 0; i < array_length(self.enemy_card_slots); i += 1) {
        self.enemy_card_slots[i].is_disabled = self.enemy.data.get_attribute("frozen") &&
                                               (i == 0 || i == array_length(self.enemy_card_slots) - 1);
    }
    
    var k = count_enabled_card_slots(self.enemy_card_slots);
        
    // Enemy plays
    self.enemy.data.new_turn();
    self.enemy.draw(5);
    var cards = self.enemy.plan_and_decide(k);
    for (var i = 0; i < array_length(self.enemy_card_slots); i += 1) {
        if (self.enemy_card_slots[i].is_disabled) {
            continue;
        }
            
        put_card_to_slot(array_pop(cards), self.enemy_card_slots[i]);
    }
        
    // Player draws
    repeat(5) {
        var card = self.draw();
        if (card == noone) {
            break;
        }
            
        self.hand.add(card.id);
    }
    
    obj_end_turn_button.is_disabled = false;
}

draw = function() {
    if (self.draw_pile.is_empty()) {
        transfer_between_piles(self.discard_pile, self.draw_pile, 0, false);
        self.draw_pile.shuffle();
    }
    
    var card = self.draw_pile.draw();
    if (instance_exists(card)) {
        card.owner = self.player.data;
        card.opponent = self.enemy.data;
        card.reveal = self.player.max_vision;
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
flip_cards = function() {
    var player_card = self.get_player_card();
    var enemy_card = self.get_enemy_card();
    if (player_card != noone) {
        player_card.state_update = player_card.state_flip;
    }
    
    if (enemy_card != noone) {
        enemy_card.state_update = enemy_card.state_flip;
    }
    
    if (!is_undefined(self.turn_timer) && time_source_exists(self.turn_timer)) {
        time_source_destroy(self.turn_timer);
    }
    
    self.turn_timer = time_source_create(
        time_source_game, 0.6, time_source_units_seconds, 
        execute_player_card
    );
    
    time_source_start(self.turn_timer);
}

execute_player_card = function() {
    var player_card = self.get_player_card();
    if (player_card != noone) {
        player_card.state_update = player_card.state_execute;
    }
    
    self.state_update = self.state_execute_player_card;
}

recycle_player_card = function() {
    var player_card = self.get_player_card();
    if (instance_exists(player_card)) {
        player_card.card_data.is_nullified = false;
        self.discard_pile.add(player_card);
        player_card.state_update = player_card.state_normal;
        player_card.image_xscale = player_card.scale;
        player_card.image_yscale = player_card.scale;
        player_card.grabbable = false; 
        player_card.reveal = 0;
    }
    
    if (self.turn_pointer < array_length(self.player_cards)) {
        self.player_cards[self.turn_pointer] = noone;
    }
    
    if (self.attempt_to_end_battle()) {
        return;
    }
    
    if (!is_undefined(self.turn_timer) && time_source_exists(self.turn_timer)) {
        time_source_destroy(self.turn_timer);
    }
    
    self.turn_timer = time_source_create(
        time_source_game, 0.5, time_source_units_seconds, 
        execute_enemy_card
    );
        
    time_source_start(self.turn_timer);
}

execute_enemy_card = function() {
    var enemy_card = self.get_enemy_card();
    if (instance_exists(enemy_card)) {
        enemy_card.state_update = enemy_card.state_execute;
    }
    
    self.state_update = self.state_execute_enemy_card;
}

recycle_enemy_card = function() {
    if (!is_undefined(self.turn_timer) && time_source_exists(self.turn_timer)) {
        time_source_destroy(self.turn_timer);
    }
    
    var enemy_card = self.get_enemy_card();
    if (instance_exists(enemy_card)) { 
        enemy_card.card_data.is_nullified = false;
        place_card(enemy_card, self.enemy.x, -500);
        enemy_card.state_update = enemy_card.state_normal;
    }
    
    self.enemy_cards[self.turn_pointer] = noone;
    if (self.attempt_to_end_battle()) {
        return;
    }
    
    self.turn_pointer += 1;
    if (self.turn_pointer == self.max_turn_pointer) {
        self.resolve_turn();
    } else {
        self.flip_cards();
    }
}

end_player_turn = function() {
    obj_end_turn_button.is_disabled = true;
    with (obj_player_card) {
        grabbable = false;
    }
    
    with (obj_enemy_card) {
        can_reveal = false;
    }
    
    // Collect both sides' cards
    for (var i = 0; i < array_length(self.player_card_slots); i += 1) {
        var card = self.player_card_slots[i].card;
        self.player_cards[i] = card;
    }
    
    for (var i = 0; i < array_length(self.enemy_card_slots); i += 1) {
        var card = self.enemy_card_slots[i].card;
        self.enemy_cards[i] = card;
    }
    
    self.turn_pointer = 0;
    self.max_turn_pointer = max(array_length(self.player_cards), array_length(self.enemy_cards));
    self.start_enemy_status();
}

start_enemy_status = function() {
    self.enemy.execute_next_status();
    self.state_update = self.state_execute_enemy_status;
}

start_player_status = function() {
    self.player.execute_next_status();
    self.state_update = self.state_execute_player_status;
}

end_battle = function() {
    instance_destroy(obj_end_turn_button);
    self.state_update = function() {};
    instance_destroy(obj_status);
    self.player.data.clear_marks_and_statuses();
    instance_destroy(obj_enemy_card);
    transfer_between_piles(self.hand, self.discard_pile, 0, false);
}

state_execute_player_card = function() {
    var player_card = self.get_player_card();
    if (player_card == noone || player_card.state_update != player_card.state_execute) {
        self.state_update = function() { }
        if (!is_undefined(self.turn_timer) && time_source_exists(self.turn_timer)) {
            time_source_destroy(self.turn_timer);
        }
        
        self.turn_timer = time_source_create(
            time_source_game, 0.5, time_source_units_seconds, 
            recycle_player_card
        );
            
        time_source_start(self.turn_timer);
    }
}

state_execute_enemy_card = function() {
    var enemy_card = self.get_enemy_card();
    if (enemy_card == noone || enemy_card.state_update != enemy_card.state_execute) {
        self.state_update = function() { }
        if (!is_undefined(self.turn_timer) && time_source_exists(self.turn_timer)) {
            time_source_destroy(self.turn_timer);
        }
        
        self.turn_timer = time_source_create(
            time_source_game, 0.5, time_source_units_seconds, 
            recycle_enemy_card
        );
            
        time_source_start(self.turn_timer);
    }
}

state_execute_enemy_status = function() {
    if (self.enemy.is_ticking_status) {
        return;
    }
    
    self.state_update = function() { };
    if (self.attempt_to_end_battle()) {
        return;
    }
    
    if (!is_undefined(self.turn_timer) && time_source_exists(self.turn_timer)) {
        time_source_destroy(self.turn_timer);
    }
    
    self.turn_timer = time_source_create(
        time_source_game, 0.5, time_source_units_seconds, 
        self.start_player_status
    );
    
    time_source_start(self.turn_timer);
}


state_execute_player_status = function() {
    if (self.player.is_ticking_status) {
        return;
    }
    
    self.state_update = function() { };
    if (self.attempt_to_end_battle()) {
        return;
    }
    
    if (!is_undefined(self.turn_timer) && time_source_exists(self.turn_timer)) {
        time_source_destroy(self.turn_timer);
    }
    
    self.turn_timer = time_source_create(
        time_source_game, 0.5, time_source_units_seconds, 
        self.flip_cards
    );
    
    time_source_start(self.turn_timer);
}

state_update = function() { }