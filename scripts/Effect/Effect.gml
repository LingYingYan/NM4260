function Effect() constructor {
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static apply = function(target, instigator, args = { multiplier: 100 }) { }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static to_string = function(target, instigator, args = { multiplier: 100 }) {
        return "Effect";
    }
}

/// @desc Function Description
/// @param {string} _modified_attribute Description
/// @param {real} _magnitude Description
function ModifierEffect(_modified_attribute, _magnitude) : Effect() constructor {
    modified_attribute = _modified_attribute;
    magnitude = _magnitude;
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static apply = function(target, instigator, args = { multiplier: 100 }) {
        target.add_modifier(self.modified_attribute, self.magnitude);
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static to_string = function(target, instigator, args = { multiplier: 100 }) {
        return "Effect";
    }
}

/// @desc Function Description
/// @param {string} _target_attribute Description
/// @param {bool} _flag Description
function FlagEffect(_target_attribute, _flag) : Effect() constructor {
    target_attribute = _target_attribute;
    flag = _flag;
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static apply = function(target, instigator, args = { multiplier: 100 }) {
        target.set_attribute(self.target_attribute, self.flag);
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static to_string = function(target, instigator, args = { multiplier: 100 }) {
        return "Effect";
    }
}

/**
 * Function Description
 * @param {real} _base_damage Description
 */
function DamageEffect(_base_damage) : Effect() constructor {
    damage = _base_damage;
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    /// @return {real} description
    static get_actual_damage = function(target, instigator, args = { multiplier: 100 }) {
        var mult = 100 + (args[$ "multiplier"] ?? 0);
        if (instigator != undefined && instigator.get_attribute("paralysed")) {
            mult -= 25;
        } 
        
        if (target != undefined && target.get_attribute("bleeding")) {
            mult += 25;
        }
        
        return max(0, floor(self.damage * mult / 100));
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static apply = function(target, instigator, args = { multiplier: 100 }) {
        var dmg = self.get_actual_damage(target, instigator, args);
        var eliminated_shields = min(target.get_attribute("shield"), dmg);
        dmg -= eliminated_shields;
        target.add_status(new Shield(-eliminated_shields));
        
        // Apply damage
        target.hp = max(target.hp - max(0, dmg), 0);
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static to_string = function(target, instigator, args = { multiplier: 100 }) {
        var dmg_text = stylise_numeric_text(self.get_actual_damage(target, instigator, args), self.damage);
        return $"Receives {dmg_text} damage";
    }
}

/**
 *  Function Description
 * @param {Struct.Mark} _mark Description
 * @param {real} _count Description
 */
function MarkEffect(_mark, _count) : Effect() constructor {
    mark = _mark
    count = _count;
    
    /// @desc Function Description
    /// @param {Struct.CharacterData} instigator Description
    /// @param {Struct.CharacterData} target Description
    /// @return {real} description 
    static get_application_count = function(instigator, target) {
        if (instigator == undefined || target == undefined) {
            return self.count;
        }
        
        return instigator.get_attribute("paralysed") ? max(0, floor(self.count * 0.75)) : self.count;
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static apply = function(target, instigator, args = { multiplier: 100 }) {
        self.mark.on_apply(target, self.get_application_count(instigator, target));
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static to_string = function(target, instigator, args = { multiplier: 100 }) {
        var mark_application_text = stylise_numeric_text(self.get_application_count(instigator, target), self.count);
        return $"{self.mark.get_label()} Mark + {mark_application_text}";
    }
}

/**
 * Function Description
 * @param {real} _base_amount Description
 */
function HealingEffect(_base_amount) : Effect() constructor {
    amount = _base_amount;
    
    /**
     * @desc Computes healing
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     * @param {Struct} args description
     */
    get_heal = function(instigator, target, args = { multiplier: 100 }) {
        if (instigator == undefined || target == undefined) {
            return self.amount;
        }
        
        var mult = 100 + (args[$ "multiplier"] ?? 0);
        if (instigator.modifiers.paralysed) {
            mult -= 25;
        }
        
        return max(0, floor(self.amount * mult / 100));
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static apply = function(target, instigator, args = { multiplier: 100 }) {
        var heal = self.get_heal(instigator, target, args);
        target.hp = min(target.max_hp, target.hp + max(0, heal));
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static to_string = function(target, instigator, args = { multiplier: 100 }) {
        var heal_text = stylise_numeric_text(self.get_heal(instigator, target, args), self.amount);
        return $"Restores {heal_text} HP";
    }
}

/**
 * Function Description
 * @param {string} _status Description
 */
function AddStatusEffect(_status, _level) : Effect() constructor {
    status_name = _status;
    level = _level;
    
    static get_actual_level = function(instigator, target, args = { multiplier: 100 }) {
        var mult = 100 + (args[$ "multiplier"] ?? 0);
        if (instigator.get_attribute("paralysed")) {
            mult -= 25;
        }
        
        return max(1, floor(self.level * mult / 100));
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static apply = function(target, instigator, args = { multiplier: 100 }) {
        var lvl = self.get_actual_level(instigator, target, args);
        var status = make_status(self.status_name, lvl);
        target.add_status(status);
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static to_string = function(target, instigator, args = { multiplier: 100 }) {
        var status = make_status(self.status_name, self.get_actual_level(instigator, target, args));
        return $"{status.get_label()} + {status.level}";
    }
}

/**
 * Function Description
 * @param {string} _status Description
 */
function RemoveStatusEffect(_status, _level) : Effect() constructor {
    status_name = _status;
    level = _level;
    
    static get_actual_level = function(instigator, target, args = { multiplier: 100 }) {
        var mult = 100 + (args[$ "multiplier"] ?? 0);
        if (instigator.get_attribute("paralysed")) {
            mult -= 25;
        }
        
        return -max(1, floor(self.level * mult / 100));
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static apply = function(target, instigator, args = { multiplier: 100 }) {
        var lvl = self.get_actual_level(instigator, target, args);
        var status = make_status(self.status_name, lvl);
        target.add_status(status);
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct} args description
    static to_string = function(target, instigator, args = { multiplier: 100 }) {
        var status = make_status(self.status_name, self.get_actual_level(instigator, target, args));
        return $"{status.get_label()} - {-status.level}";
    }
}
