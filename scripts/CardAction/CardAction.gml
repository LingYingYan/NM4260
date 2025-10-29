/// @desc Function Description
/// @param {Function} on_performed Description
/// @param {array<Struct.CardData>} _cards Description
/// @param {Struct.Dummy} _self_dummy Description
/// @param {Struct.Dummy} _player_dummy Description
function CardAction(on_performed, _cards, _self_dummy, _player_dummy) : Action(on_performed) constructor {
    cards = _cards;
    self_dummy = _self_dummy;
    player_dummy = _player_dummy;
    
    static parent_evaluate = self.evaluate;
    
    static evaluate = function(context) {
        self.self_dummy.reset_data();
        self.player_dummy.reset_data();
        
        var old_self_lost_hp = self.self_dummy.max_hp - self.self_dummy.hp;
        var old_self_hp = self.self_dummy.hp;
        var old_self_max_hp = self.self_dummy.max_hp;
        var old_player_hp = self.player_dummy.hp;
        var old_player_statuses = { };
        for (var i = 0; i < array_length(self.player_dummy.status_effects); i += 1) {
            old_player_statuses[$ self.player_dummy.status_effects[i].name] = self.player_dummy.status_effects[i].level;
        }
        
        var old_self_statuses = { };
        for (var i = 0; i < array_length(self.self_dummy.status_effects); i += 1) {
            old_player_statuses[$ self.self_dummy.status_effects[i].name] = self.self_dummy.status_effects[i].level;
        }
        
        // Simulate cards
        for (var i = 0; i < array_length(self.cards); i += 1) {
            var card = self.cards[i];
            card.simulate_effects(self.self_dummy, self.player_dummy);
        }
        
        var self_healing = max(0, self.self_dummy.hp - old_self_hp);
        var player_damage = max(0, old_player_hp - self.player_dummy.hp);
        var self_damage = max(0, old_self_hp - self.self_dummy.hp);
        
        // Set up context variables
        context[$ "healing_to_lost_hp_ratio"] = old_self_lost_hp == 0 ? 0 : self_healing / old_self_lost_hp;
        context[$ "healing_to_remaining_ratio"] = self_healing / old_self_hp;
        context[$ "remaining_hp_percentage"] = old_self_hp / old_self_max_hp;
        
        context[$ "damage_to_player_hp_ratio"] = player_damage / old_player_hp;
        
        context[$ "immediate_status_damage_to_player_hp_ratio"] = 0;
        for (var i = 0; i < array_length(self.player_dummy.status_effects); i += 1) {
            var status = self.player_dummy.status_effects[i];
            if (!struct_exists(old_player_statuses, status.name) || old_player_statuses[$ status.name] < status.level) {
                context[$ "immediate_status_damage_to_player_hp_ratio"] += calculate_immediate_damage(status.name);
            }
        }
        
        context[$ "projected_status_damage_to_player_hp_ratio"] = 0;
        for (var i = 0; i < array_length(self.player_dummy.status_effects); i += 1) {
            var status = self.player_dummy.status_effects[i];
            if (!struct_exists(old_player_statuses, status.name) || old_player_statuses[$ status.name] < status.level) {
                context[$ "immediate_status_damage_to_player_hp_ratio"] += (calculate_projected_damage(status.name, status.level - (old_player_statuses[$ status.name] ?? 0)) - calculate_immediate_damage(status.name));
            }
        }
        
        context[$ "frozen_normalised_duration"] = (self.player_dummy.count_status("Frozen") - (old_player_statuses[$ "Frozen"] ?? 0)) * 0.2;
        context[$ "paralysed_normalised_duration"] = (self.player_dummy.count_status("Paralysed") - (old_player_statuses[$ "Paralysed"] ?? 0)) * 0.2;
        context[$ "bleed_normalised_duration"] = (self.player_dummy.count_status("Bleed") - (old_player_statuses[$ "Bleed"] ?? 0)) * 0.2;
        
        var strength = (self.self_dummy.count_status("Strength") - (old_self_statuses[$ "Strength"] ?? 0))
        context[$ "projected_extra_damage_to_player_hp_ratio"] = min(1, (self.self_dummy.count_status("Strength") * (1 - power(0.5, strength)) / (1 - 0.5)) / self.player_dummy.hp);
        
        var coalesence = (self.self_dummy.count_status("Coalesence") - (old_self_statuses[$ "Coalesence"] ?? 0))
        context[$ "projected_healing_to_lost_hp_ratio"] = min(1, 5 * (1 - power(0.5, coalesence)) / (1 - 0.5));
        
        context[$ "self_damage_ratio_to_remaining_hp"] = self_damage / old_self_hp;
        context[$ "self_status_immediate_damage_to_hp_ratio"] = 0;
        for (var i = 0; i < array_length(self.self_dummy.status_effects); i += 1) {
            var status = self.self_dummy.status_effects[i];
            if (!struct_exists(old_self_statuses, status.name) || old_self_statuses[$ status.name] < status.level) {
                context[$ "self_status_immediate_damage_to_hp_ratio"] += calculate_immediate_damage(status.name);
            }
        }
        
        context[$ "self_status_projected_damage_to_hp_ratio"] = 0;
        for (var i = 0; i < array_length(self.self_dummy.status_effects); i += 1) {
            var status = self.self_dummy.status_effects[i];
            if (!struct_exists(old_self_statuses, status.name) || old_self_statuses[$ status.name] < status.level) {
                context[$ "self_status_projected_damage_to_hp_ratio"] += (calculate_projected_damage(status.name, status.level - (old_self_statuses[$ status.name] ?? 0)) - calculate_immediate_damage(status.name));
            }
        }
        
        return self.parent_evaluate(context);
    }
}