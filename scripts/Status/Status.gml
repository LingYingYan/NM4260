/// @desc A status effect
/// @param {real} _level Level of the effect
/// @param {string} _name Name of the effect
function Status(_level, _name) constructor {
    level = _level;
    name = _name;
    
    /// @desc Called when the effect is added for the first time
    /// @param {Struct.GameCharacterData} target The target
    static initialise = function(target) { }
    
    /// @desc Called when the effect is added
    /// @param {Struct.GameCharacterData} target The target
    static activate = function(target) { }
    
    /// @desc Called when the effect ticks
    /// @param {Struct.GameCharacterData} target The target
    static execute = function(target) { }
    
    /// @desc Called when the effect is removed.
    /// @param {Struct.GameCharacterData} target The target
    static terminate = function(target) { }
    
    static decay = function(target) { 
        self.level -= 1;
    }
    
    static get_label = function(highlight = false) {
        if (highlight) {
            return $"[region,keyword-status-{self.name}][c_white][scale,0.0234375][spr_{string_lower(self.name)}][/s][/c] [wheel][c_gold][b]{self.name}[/b][/c][/wheel][/region]";
        }
        
        return $"[region,keyword-status-{self.name}][c_white][scale,0.0234375][spr_{string_lower(self.name)}][/s][/c] [c_gold][b]{self.name}[/b][/c][/region]";
    }
}

function get_coloured_label(status_name) {
    var icon = $"[c_white][scale,0.03125][spr_{string_lower(status_name)}][/s][/c]";
    switch (status_name) {
    	case "Burn":
            return icon + $"[c_orange][b]{status_name}![/b][/c]";
        case "Poison":
            return icon + $"[c_green][b]{status_name}![/b][/c]";
        case "Paralysed":
            return icon + $"[c_purple][b]{status_name}![/b][/c]";
        case "Frozen":
            return icon + $"[c_aqua][b]{status_name}![/b][/c]";
        case "Shield":
            return icon + $"[c_gray][b]{status_name}![/b][/c]";
        case "Strength":
            return icon + $"[c_red][b]{status_name}![/b][/c]";
        case "Coalesence":
            return icon + $"[c_lime][b]{status_name}![/b][/c]";
        case "Bleed":
            return icon + $"[c_maroon][b]{status_name}![/b][/c]";
    }
}

/// @desc Function Description
/// @param {string} type Description
/// @param {real} level Description
/// @return {Struct.Status}
function make_status(type, level) {
    switch (type) {
    	case "Burn":
            return new Burn(level);
        case "Poison":
            return new Poison(level);
        case "Paralysed":
            return new Paralysed(level);
        case "Frozen":
            return new Frozen(level);
        case "Shield":
            return new Shield(level);
        case "Strength":
            return new Strength(level);
        case "Coalesence":
            return new Coalesence(level);
        case "Bleed":
            return new Bleed(level);
    }
}

function describe_status(type) {
    switch (type) {
    	case "Burn":
            return "Each layer of Burn: [b]-1 HP per turn[/b].\nDecays by [b]1[/b] layer after every turn.";
        case "Poison":
            return "Each layer of Poison: [b]-1 HP per turn[/b].\nDecays by [b]1[/b] layer after every turn.";
        case "Paralysed":
            return "[b]-25% card power[/b] until the status wears off.\nDecays by [b]1[/b] layer after every turn.";
        case "Frozen":
            return "Only able to play [b]1[/b] card every turn until the status wears off.\nDecays by [b]1[/b] layer after every turn.";
        case "Shield":
            return "Each layer of Shield cancels with [b]1[/b] damage.\nShields [b]do not carry forward[/b] to the next turn.";
        case "Strength":
            return "Each layer of Strength: [b]Destruction[/b] card damage [b]+1[/b].\nDecays by [b]1[/b] layer after every turn.";
        case "Coalesence":
            return "[b]+3[/b] HP per turn until the status wears off.\nDecays by [b]1[/b] layer after every turn.";
        case "Bleed":
            return "Suffers [b]25% more damage[/b] from [b]Destruction[/b] cards until the status wears off.\nDecays by [b]1[/b] layer after every turn.";
    }
}

function project_status_effect(type, level) {
    switch (type) {
    	case "Burn":
            return $"[b]-{calculate_immediate_damage(type)}[/b] HP in the next turn";
        case "Poison":
            return $"[b]-{calculate_immediate_damage(type)}[/b] HP in the next turn";
        case "Paralysed":
            return $"[b]-25% card power[/b] for [b]{level}[/b] turns";
        case "Frozen":
            return $"For the next [b]{level}[/b] turns, only able to play [b]1[/b] card per turn";
        case "Shield":
            return $"Cancels up to [b]{level}[/b] damage dealt by [b]Destruction[/b] cards";
        case "Strength":
            return $"[b]Destruction[/b] card damage [b]+{level}[/b]";
        case "Coalesence":
            return $"[b]+5[/b] HP per turn, for [b]{level}[/b] turns";
        case "Bleed":
            return $"Suffers [b]25% more damage[/b] from [b]Destruction[/b] cards for [b]{level}[/b] turns";
    }
}

function calculate_immediate_damage(type) {
    switch (type) {
    	case "Burn": 
        case "Poison":
            return 3;
        default:
            return 0;
    }
}

function calculate_projected_damage(type, level) {
    var dmg = calculate_immediate_damage(type);
    if (dmg == 0) {
        return 0
    }
    
    return dmg * (1 - power(0.5, level)) / (1 - 0.5);
}

function Burn(_level) : Status(_level, nameof(Burn)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    static execute = function(target) { 
        target.hp -= 3;
    }
} 

function Poison(_level) : Status(_level, nameof(Poison)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    static execute = function(target) { 
        target.hp -= 3;
    }
} 

function Paralysed(_level) : Status(_level, nameof(Paralysed)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    static initialise = function(target) { 
        target.set_attribute("paralysed", true);
    }
    
    /// @desc Called when the effect is removed.
    /// @param {Struct.GameCharacterData} target The target
    static terminate = function(target) { 
        target.set_attribute("paralysed", false);
    }
} 

function Frozen(_level) : Status(_level, nameof(Frozen)) constructor {
    /// @desc Called when the effect is added for the first time
    /// @param {Struct.GameCharacterData} target The target
    static initialise = function(target) {
        target.set_attribute("frozen", true);
    }
    
    /// @desc Called when the effect is removed.
    /// @param {Struct.GameCharacterData} target The target
    static terminate = function(target) { 
        target.set_attribute("frozen", false);
    }
} 

function Shield(_level) : Status(_level, nameof(Shield)) constructor {
    /// @desc Called when the effect is added
    /// @param {Struct.GameCharacterData} target The target
    static activate = function(target) { 
        target.add_modifier("shield", self.level);
    }
    
    /// @desc Called when the effect is removed.
    /// @param {Struct.GameCharacterData} target The target
    static terminate = function(target) { 
        target.add_modifier("shield", -self.level);
    }
    
    static decay = function(target) { 
        self.level = 0;
    }
}

function Strength(_level) : Status(_level, nameof(Strength)) constructor {
    /// @desc Called when the effect is added
    /// @param {Struct.GameCharacterData} target The target
    static activate = function(target) { 
        target.add_modifier("strength", self.level);
    }
    
    static decay = function(target) { 
        self.level -= 1;
        target.add_modifier("strength", -1);
    }
}

function Coalesence(_level) : Status(_level, nameof(Coalesence)) constructor {
    /// @desc Called when the effect is added for the first time
    /// @param {Struct.GameCharacterData} target The target
    static initialise = function(target) { 
        target.set_attribute("coalescencing", true);
    }
    
    /// @desc Called when the effect is added
    /// @param {Struct.GameCharacterData} target The target
    static activate = function(target) { }
    
    /// @desc Called when the effect ticks
    /// @param {Struct.GameCharacterData} target The target
    static execute = function(target) { 
        target.hp += 3;
    }
    
    /// @desc Called when the effect is removed.
    /// @param {Struct.GameCharacterData} target The target
    static terminate = function(target) { 
        target.set_attribute("coalescencing", false);
    }
}

function Bleed(_level) : Status(_level, nameof(Bleed)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    static initialise = function(target) { 
        target.set_attribute("bleeding", false);
    }
    
    /// @desc Called when the effect is removed.
    /// @param {Struct.GameCharacterData} target The target
    static terminate = function(target) { 
        target.set_attribute("bleeding", false);
    }
}


