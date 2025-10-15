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
}

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
        target.modifiers.card_effectiveness -= 25;
    }
} 

function Frozen(_level) : Status(_level, nameof(Frozen)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.GameCharacterData} target The target
    execute = function(target) { 
        target.modifiers.frozen_slots += 2;
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
