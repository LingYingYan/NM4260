/// @desc A status effect
/// @param {real} _level Level of the effect
/// @param {string} _name Name of the effect
function Status(_level, _name) constructor {
    level = _level;
    name = _name;
    
    /// @desc Execute the status effect
    /// @param {Struct.CharacterData} target The target
    execute = function(target) { }
}

function Burn(_level) : Status(_level, nameof(Burn)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.CharacterData} target The target
    execute = function(target) { 
        target.hp -= self.level;
        self.level -= 1;
    }
} 

function Poison(_level) : Status(_level, nameof(Poison)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.CharacterData} target The target
    execute = function(target) { 
        target.hp -= self.level;
        self.level -= 1;
    }
} 

function Paralysed(_level) : Status(_level, nameof(Paralysed)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.CharacterData} target The target
    execute = function(target) { 
        self.level -= 1;
    }
} 

function Frozen(_level) : Status(_level, nameof(Frozen)) constructor {
    /// @desc Execute the status effect
    /// @param {Struct.CharacterData} target The target
    execute = function(target) { 
        self.level -= 1;
    }
} 
