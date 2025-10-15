function GameCharacterData(curr_hp, total_hp) constructor {
    hp = curr_hp;
    max_hp = total_hp;
    shields = 0
    status_effects = ds_map_create();
    marks = ds_map_create();
    card_effectiveness_modifier = 0;
    
    modifiers = {
        card_effectiveness: 0,
        strength: 0,
        shield: 0
    };
    
    /// @desc description
    /// @param {Struct.Status} status description description
    add_status = function(status) {
        if (status.level == 0) {
            return;
        }
        
        if (!ds_map_exists(self.status_effects, status.name)) {
            ds_map_add(self.status_effects, status.name, status);
        } else {
            self.status_effects[? status.name].level += status.level;
        }
        
        status.initialise(self);
        
        if (self.status_effects[? status.name].level <= 0) {
            ds_map_delete(self.status_effects, status.name);
        } 
    }
    
    reset_modifiers = function() {
        self.modifiers = {
            card_effectiveness: 0,
            strength: 0,
            shield: 0
        };
    }
    
    execute_status_effects = function() {
        var to_remove = [];
        var key = ds_map_find_first(self.status_effects);
        while (key != undefined) {
            self.status_effects[? key].execute(self);
            key = ds_map_find_next(self.status_effects, key);
        }
        
        for (var i = 0; i < array_length(to_remove); i += 1) {
        	ds_map_delete(self.status_effects, to_remove[i]);
        }
    }
    
    update_status_effects = function() {
        var to_remove = [];
        var key = ds_map_find_first(self.status_effects);
        while (key != undefined) {
            self.status_effects[? key].decay();
            if (self.status_effects[? key].level <= 0) {
                array_push(to_remove, key);
            }
            
            key = ds_map_find_next(self.status_effects, key);
        }
        
        for (var i = 0; i < array_length(to_remove); i += 1) {
        	ds_map_delete(self.status_effects, to_remove[i]);
        }
    }
    
    add_marks = function(mark_id, multiplicity) {
        if (mark_id == "none") {
            return;
        }
        
        if (!ds_map_exists(self.marks, mark_id)) {
            if (multiplicity > 0) {
                ds_map_add(self.marks, mark_id, multiplicity);
            }
        } else {
            self.marks[? mark_id] += multiplicity;
            if (self.marks[? mark_id] <= 0) {
                ds_map_delete(self.marks, mark_id);
            }
        }
    }
    
    count_mark = function(mark_id) {
        return ds_map_exists(self.marks, mark_id) ? self.marks[? mark_id] : 0;
    }
    
    clear_marks_and_statuses = function() {
        ds_map_clear(self.marks);
        ds_map_clear(self.status_effects);
    }
}

function PlayerData(curr_hp, total_hp, curr_vision, total_vision) : GameCharacterData(curr_hp, total_hp) constructor {
    vision = curr_vision; 
    max_vision = total_vision;
}

/// @desc Function Description
/// @param {string} enemy_id Description
/// @param {string} enemy_name Description
/// @param {real} enemy_weight description
function EnemyData(enemy_id, enemy_name, enemy_weight, enemy_hp) : GameCharacterData(enemy_hp, enemy_hp) constructor {
    uid = enemy_id;
    name = enemy_name;
    weight = enemy_weight;
    card_uids = [];
    cards = [];
    
    add_cards = function(card_uid, count) {
        repeat (count) {
            var size = array_length(self.card_uids);
        	self.card_uids[size] = card_uid;
        }
    }
    
    clone = function() {
        var enemy = new EnemyData(self.uid, self.name, self.weight, self.max_hp);   
        for (var i = 0; i < array_length(self.card_uids); i += 1) {
            enemy.card_uids[i] = self.card_uids[i];
            enemy.cards[i] = res_loader_cards.loaded_map[? self.card_uids[i]].clone();
        }
        
        return enemy;
    } 
}
