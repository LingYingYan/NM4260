/**
 * Function Description
 * @param {Struct.CharacterData} _instigator Description
 * @param {Struct.CharacterData} _target Description
 * @param {real} power_mult Description
 */
function EffectApplicationArgs(_instigator, _target, power_mult = 0) constructor {
    instigator = _instigator;
    target = _target;
    mult = power_mult;
}

/**
 * Function Description
 */
function Effect() constructor {
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    static apply = function(args) { }
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    /// @param {bool} [vaguely]=false description
    static to_string = function(args, vaguely = false, highlight = false) {
        return "Effect";
    }
    
    static remove = function(source) { }
}

/// @desc Function Description
/// @param {string} _modified_attribute Description
/// @param {real} _magnitude Description
function ModifierEffect(_modified_attribute, _magnitude) : Effect() constructor {
    modified_attribute = _modified_attribute;
    magnitude = _magnitude;
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    static apply = function(args) {
        args.target.add_modifier(self.modified_attribute, self.magnitude);
    }
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    /// @param {bool} [vaguely]=false description
    static to_string = function(args, vaguely = false, highlight = false) {
        return $"[b]{get_modifier_display_name(self.modified_attribute)}[/b] {self.magnitude >= 0 ? "+" : ""}{self.magnitude}";
    }
    
    static remove = function(source) { 
        source.add_modifier(self.modified_attribute, -self.magnitude);
    }
}

/// @desc Function Description
/// @param {string} _target_attribute Description
/// @param {bool} _flag Description
function FlagEffect(_target_attribute, _flag) : Effect() constructor {
    target_attribute = _target_attribute;
    flag = _flag;
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    static apply = function(args) {
        args.target.set_attribute(self.target_attribute, self.flag);
    }
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    /// @param {bool} [vaguely]=false description
    static to_string = function(args, vaguely = false, highlight = false) {
        return "Effect";
    }
    
    static remove = function(source) { 
        source.set_attribute(self.target_attribute, !self.flag);
    }
}

/**
 * Function Description
 * @param {real} _base_damage Description
 */
function DamageEffect(_base_damage) : Effect() constructor {
    damage = _base_damage;
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    /// @return {real} description
    static get_actual_damage = function(args) {
        var mult = 100 + args.mult;
        if (args.instigator != undefined && args.instigator.get_attribute("paralysed")) {
            mult -= 25;
        } 
        
        if (args.target != undefined && args.target.get_attribute("bleeding")) {
            mult += 25;
        }
        
        return max(0, floor(self.damage * mult / 100));
    }
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    static apply = function(args) {
        var dmg = self.get_actual_damage(args);
        var eliminated_shields = min(args.target.get_attribute("shield"), dmg);
        dmg -= eliminated_shields;
        args.target.add_status(new Shield(-eliminated_shields));
        
        // Apply damage
        args.target.hp = max(args.target.hp - max(0, dmg), 0);
    }
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    /// @param {bool} [vaguely]=false description
    static to_string = function(args, vaguely = false, highlight = false) {
        var dmg_text = stylise_numeric_text(self.get_actual_damage(args), self.damage);
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
    /// @param {Struct.EffectApplicationArgs} args description
    static get_application_count = function(args) {
        if (args == undefined || args.instigator == undefined || args.target == undefined) {
            return self.count;
        }
        
        var mult = 100 + args.mult;
        if (args.instigator.get_attribute("paralysed")) {
            mult -= 25;
        }
        
        return sign(self.count) * max(0, floor(abs(self.count) * mult / 100));
    }
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    static apply = function(args) {
        self.mark.on_apply(args.target, self.get_application_count(args));
    }
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    /// @param {bool} [vaguely]=false description
    static to_string = function(args, vaguely = false, highlight = false) {
        var application_count = self.get_application_count(args);
        var mark_application_text = stylise_numeric_text(application_count, self.count);
        return vaguely 
            ? $"{self.mark.get_label(highlight)} Mark {application_count >= 0 ? "+" : ""}?" 
            : $"{self.mark.get_label(highlight)} Mark {application_count >= 0 ? "+" : ""}{mark_application_text}";
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
     * @param {Struct.EffectApplicationArgs} args description
     */
    get_heal = function(args) {
        if (args == undefined || args.instigator == undefined || args.target == undefined) {
            return self.amount;
        }
        
        var mult = 100 + args.mult;
        if (args.instigator.get_attribute("paralysed")) {
            mult -= 25;
        }
        
        return max(0, floor(self.amount * mult / 100));
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct.EffectApplicationArgs} args description
    static apply = function(args) {
        var heal = self.get_heal(args);
        args.target.hp = min(args.target.max_hp, args.target.hp + max(0, heal));
    }
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    /// @param {bool} [vaguely]=false description
    static to_string = function(args, vaguely = false, highlight = false) {
        var heal_text = stylise_numeric_text(self.get_heal(args), self.amount);
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
    
    static get_actual_level = function(args) {
        var mult = 100 + args.mult;
        if (args.instigator.get_attribute("paralysed")) {
            mult -= 25;
        }
        
        return sign(self.level) * max(0, floor(abs(self.level) * mult / 100));
    }
    
    /// @desc 
    /// @param {Struct.CharacterData} target description
    /// @param {Struct.CharacterData} instigator description
    /// @param {Struct.EffectApplicationArgs} args description
    static apply = function(args) {
        var lvl = self.get_actual_level(args);
        var status = make_status(self.status_name, lvl);
        args.target.add_status(status);
    }
    
    /// @desc 
    /// @param {Struct.EffectApplicationArgs} args description
    /// @param {bool} [vaguely]=false description
    static to_string = function(args, vaguely = false, highlight = false) {
        var status = make_status(self.status_name, self.get_actual_level(args));
        return vaguely 
            ? $"{status.get_label(highlight)} {status.level >= 0 ? "+" : ""}?" 
            : $"{status.get_label(highlight)} {status.level >= 0 ? "+" : ""}{status.level}";
    }
}


/**
 * Function Description
 * @param {Struct} data Description
 * @param {Struct.CardData} card description
 * @return {Struct.Effect,undefined} description
 */
function make_effect(data, card) {
    switch (data.type) {
        case "Damage":
            return new DamageEffect(data.value);
        case "Heal":
            return new HealingEffect(data.value);
        case "AddStatus":
            return new AddStatusEffect(data.status_name, data.value);
        case "Mark":
            return new MarkEffect(card.mark, data.value);
        case "RemoveMark":
            return new MarkEffect(make_mark(data.mark_id), -data.value);
        default:
            return undefined;
    }
}