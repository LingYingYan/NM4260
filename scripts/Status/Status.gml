/// @desc A status effect
/// @param {real} _level Level of the effect
/// @param {string} _name Name of the effect
function Status(_level, _name) constructor {
    level = _level;
    name = _name;
    
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    initialise = function(target) { }
    
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    execute = function(target) { }
    
    decay = function() { 
        self.level -= 1;
    }
    
    get_label = function() {
        return $"[region,keyword-status-{self.name}][c_white][spr_{string_lower(self.name)}_small][/c][c_gold][b]{self.name}[/b][/c][/region]"
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
            return "Each layer of Burn causes [b]-1 HP per turn[/b].\nDecays by [b]1[/b] layer after every turn.";
        case "Poison":
            return "Each layer of Poison causes [b]-1 HP per turn[/b].\nDecays by [b]1[/b] layer after every turn.";
        case "Paralysed":
            return "[b]-25% card power[/b] until the status wears off.\nDecays by [b]1[/b] layer after every turn.";
        case "Frozen":
            return "Only able to play [b]1[/b] card every turn until the status wears off.\nDecays by [b]1[/b] layer after every turn.";
        case "Shield":
            return "Each layer of Shield cancels with [b]1[/b] damage.\nShields [b]do not carry forward[/b] to the next turn.";
        case "Strength":
            return "Each layer of Strength increases direct damage dealt with [b]Destruction[/b] cards by [b]1[/b].\nDecays by [b]1[/b] layer after every turn.";
        case "Coalesence":
            return "[b]+5[/b] HP per turn until the status wears off.\nDecays by [b]1[/b] layer after every turn.";
        case "Bleed":
            return "Suffers [b]25% more damage[/b] from [b]Destruction[/b] cards.\nDecays by [b]1[/b] layer after every turn.";
    }
}

function project_status_effect(type, level) {
    switch (type) {
    	case "Burn":
            return $"Deals [b]{level}[/b] damage in the next turn";
        case "Poison":
            return $"Deals [b]{level}[/b] damage in the next turn";
        case "Paralysed":
            return $"[b]-25% card power[/b] for [b]{level}[/b] turns";
        case "Frozen":
            return $"Only able to play [b]1[/b] card for [b]{level}[/b] turns";
        case "Shield":
            return $"Cancels up to [b]{level}[/b] damage dealt by [b]Destruction[/b] cards";
        case "Strength":
            return $"Increases direct damage dealt with [b]Destruction[/b] cards by [b]{level}[/b]";
        case "Coalesence":
            return $"[b]+5[/b] HP per turn, for [b]{level}[/b] turns";
        case "Bleed":
            return $"Suffers [b]25% more damage[/b] from [b]Destruction[/b] cards for [b]{level}[/b] turns";
    }
}

function Burn(_level) : Status(_level, nameof(Burn)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    execute = function(target) { 
        target.hp -= self.level;
    }
} 

function Poison(_level) : Status(_level, nameof(Poison)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    execute = function(target) { 
        target.hp -= self.level;
    }
} 

function Paralysed(_level) : Status(_level, nameof(Paralysed)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    execute = function(target) { 
        target.modifiers.paralysed = true;
    }
} 

function Frozen(_level) : Status(_level, nameof(Frozen)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    execute = function(target) { 
        target.modifiers.frozen = true;
    }
} 

function Shield(_level) : Status(_level, nameof(Shield)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    initialise = function(target) { 
        target.modifiers.shield += self.level;
    }
    
    decay = function() { 
        self.level = 0;
    }
}

function Strength(_level) : Status(_level, nameof(Strength)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    initialise = function(target) { 
        target.modifiers.strength += self.level;
    }
}

function Coalesence(_level) : Status(_level, nameof(Coalesence)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    initialise = function(target) { 
        target.modifiers.coalesencing = true;
    }
}

function Bleed(_level) : Status(_level, nameof(Bleed)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    initialise = function(target) { 
        target.modifiers.bleeding = true;
    }
}


