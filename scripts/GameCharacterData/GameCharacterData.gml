function GameCharacterData(curr_hp, total_hp) constructor {
    hp = curr_hp;
    max_hp = total_hp;
    status_effects = [];
    expired_statuses = [];
    marks = { };
    
    modifiers = { };
    
    /// @desc 
    /// @param {string} name description
    static get_attribute = function(name) {
        return self.modifiers[$ name] ?? 0;
    }
    
    /// @desc 
    /// @param {string} name description
    /// @param {real,bool} value description
    static set_attribute = function(name, value) {
        self.modifiers[$ name] = value;
    }
    
    /// @desc 
    /// @param {string} name description
    /// @param {real} modifier_value description
    static add_modifier = function(name, modifier_value) {
        self.set_attribute(name, self.get_attribute(name) + modifier_value);
    }
    
    static sort_status = function() {
        array_sort(self.status_effects, function(left, right) {
            if (left.name < right.name) {
                return -1;    
            }    
                    
            if (left.name > right.name) {
                return 1;
            }
                    
            return 0;
        });
    }
    
    /// @desc description
    /// @param {Struct.Status} status description description
    /// @param {bool} [success]=true description
    /// @return {bool} description
    static add_status = function(status, success = true) { 
        if (status.level == 0) {
            return false;
        }
        
        if (success) {
            var curr_status = undefined;
            var idx = -1;
            for (var i = 0; i < array_length(self.status_effects); i += 1) {
                if (self.status_effects[i].name == status.name) {
                    curr_status = self.status_effects[i];
                    idx = i;
                    break;    
                }                
            }
            
            if (curr_status == undefined) {
                array_push(self.status_effects, status);
                // Added for the first time
                status.initialise(self);
            } else {
                curr_status.level += status.level;
                if (curr_status.level <= 0) {
                    array_delete(self.status_effects, idx, 1);
                } 
            }
            
            // Activate no matter what
            status.activate(self);
            self.sort_status();
        }
        
        return true;
    }
    
    static tick_status_effects = function() { 
        var to_remove = [];
        for (var i = 0; i < array_length(self.status_effects); i += 1) {
            if (self.status_effects[i].level <= 0) {
                array_push(to_remove, i);
            }
        }
        
        for (var i = 0; i < array_length(to_remove); i += 1) {
            array_delete(self.status_effects, to_remove[i], 1);
        }
        
        self.sort_status();
    }
    
    static add_marks = function(mark_id, multiplicity) { 
        if (mark_id == "none" || multiplicity == 0) {
            return false;
        }
        
        if (!struct_exists(self.marks, mark_id)) {
            if (multiplicity <= 0) {
                return false;
            }
            
            self.marks[$ mark_id] = multiplicity;
        } else {
            self.marks[$ mark_id] += multiplicity;
            if (self.marks[$ mark_id] <= 0) {
                struct_remove(self.marks, mark_id);
            }
        }
        
        return true;
    }
    
    static count_mark = function(mark_id) {
        return self.marks[$ mark_id] ?? 0;
    }
    
    static count_status = function(status_name) {
        for (var i = 0; i < array_length(self.status_effects); i += 1) {
            if (self.status_effects[i].name == status_name) {
                return self.status_effects[i].level;
            }
        }
        
        return 0;
    }
    
    static clear_marks_and_statuses = function() {
        self.marks = {};
        self.status_effects = [];
    }
}

function PlayerData(curr_hp, total_hp, curr_vision, total_vision) : GameCharacterData(curr_hp, total_hp) constructor {
    vision = curr_vision; 
    max_vision = total_vision;
    traits = [];
    timed_relics = [];
    
    static parent_add_status = self.add_status;
    static parent_add_marks = self.add_marks;
    
    /// @desc description
    /// @param {Struct.Status} status description description
    /// @return {bool} description
    static add_status = function(status, success = true) {
        if (!self.parent_add_status(status, success)) {
            return false;
        }
        
        obj_player_state.add_status(status, success);
        return true;
    }
    
    static add_marks = function(mark_id, multiplicity) {
        if (!self.parent_add_marks(mark_id, multiplicity)) {
            return false;
        }
        
        obj_player_state.add_marks(mark_id, multiplicity);
        return true;
    }
    
    static use_relic = function(relic) {
        if (relic.duration > 0) {
            array_push(self.timed_relics, { item: relic, expire_time: global.number_of_completed_combat + relic.duration});
        }
    }
    
    static remove_expired_relics = function() {
        var to_remove = [];
        for (var i = 0; i < array_length(self.timed_relics); i += 1) {
            if (self.timed_relics[i].expire_time >= global.number_of_completed_combat) {
                self.timed_relics[i].item.revoke(self);
                array_push(to_remove, i);
            }
        }
        
        for (var i = 0; i < array_length(to_remove); i += 1) {
            array_delete(self.timed_relics, to_remove[i], 1);
        }
    }
}

/// @desc Function Description
/// @param {string} enemy_id Description
/// @param {string} enemy_name Description
/// @param {real} enemy_weight description
function EnemyData(enemy_id, enemy_name, enemy_weight, enemy_hp) : GameCharacterData(enemy_hp, enemy_hp) constructor {
    uid = enemy_id;
    name = enemy_name;
    weight = enemy_weight;
    cards = [];
    
    static parent_add_status = self.add_status;
    static parent_add_marks = self.add_marks;
    
    static clone = function() {
        var enemy = new EnemyData(self.uid, self.name, self.weight, self.max_hp);   
        return enemy;
    } 
    
    /// @desc description
    /// @param {Struct.Status} status description description
    static add_status = function(status, success = true) {
        if (!self.parent_add_status(status, success)) {
            return false;
        }
        
        obj_enemy.add_status(status.name, status.level, success);
        return true;
    }
    
    static add_marks = function(mark_id, multiplicity) {
        if (!self.parent_add_marks(mark_id, multiplicity)) {
            return false;
        }
        
        obj_enemy.add_marks(mark_id, multiplicity);
        return true;
    }
}

function Dummy(character) : GameCharacterData(0, 0) constructor {
    hp = character.hp;
    max_hp = character.max_hp;
    source = character;
    
    static reset_data = function() {
        var attribute_names = struct_get_names(self.source.modifiers);
        for (var i = 0; i < array_length(attribute_names); i += 1) {
            self.set_attribute(attribute_names[i], self.source.get_attribute(attribute_names[i]));
        }
        
        var mark_ids = struct_get_names(self.source.marks);
        for (var i = 0; i < array_length(mark_ids); i += 1) {
            self.add_marks(mark_ids[i], self.source.count_mark(mark_ids[i]));
        }
        
        for (var i = 0; i < array_length(self.source.status_effects); i += 1) {
            self.add_status(make_status(self.source.status_effects[i].name, self.source.status_effects[i].level));
        }
    }
}
