function GameCharacterData(curr_hp, total_hp) constructor {
    hp = curr_hp;
    max_hp = total_hp;
    status_effects = [];
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
                array_sort(self.status_effects, function(left, right) {
                    if (left.name < right.name) {
                        return -1;    
                    }    
                    
                    if (left.name > right.name) {
                        return 1;
                    }
                    
                    return 0;
                })
                
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
        }
        
        return true;
    }
    
    static execute_status_effects = function() {
        // TODO
        var to_remove = [];
        for (var i = 0; i < array_length(self.status_effects); i += 1) {
            if (self.status_effects[i].level <= 0) {
                array_push(to_remove, i);
            }
        }
        
        for (var i = 0; i < array_length(to_remove); i += 1) {
            array_delete(self.status_effects, to_remove[i], 1);
        }
    }
    
    static tick_status_effects = function() { 
        
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
    
    static clear_marks_and_statuses = function() {
        self.marks = {};
        self.status_effects = [];
    }
}

function PlayerData(curr_hp, total_hp, curr_vision, total_vision) : GameCharacterData(curr_hp, total_hp) constructor {
    vision = curr_vision; 
    max_vision = total_vision;
    traits = [];
    
    static parent_add_status = self.add_status;
    static parent_add_marks = self.add_marks;
    
    /// @desc description
    /// @param {Struct.Status} status description description
    /// @return {bool} description
    static add_status = function(status, success = true) {
        if (!self.parent_add_status(status, success)) {
            return false;
        }
        
        obj_player_state.add_status(status.name, status.level, success);
        return true;
    }
    
    static add_marks = function(mark_id, multiplicity) {
        if (!self.parent_add_marks(mark_id, multiplicity)) {
            return false;
        }
        
        obj_player_state.add_marks(mark_id, multiplicity);
        return true;
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
