
/**
 * Function Description
 * @param {string} _id Description
 * @param {string} _name Description
 * @param {string} _desc Description
 * @param {real} _rarity description
 * @param {real} _duration description
 * @param {array<Struct.Effect>} _effects description
 */
function Relic(_id, _name, _desc, _rarity, _duration, _effects = []) constructor {
    uid = _id;
    name = _name;
    desc = _desc;
    rarity = _rarity;
    duration = _duration;
    effects = _effects;
    
    static get_weight = function() {
        return 5 - self.rarity;
    }
     
    static add_effect = function(effect) {
        array_push(self.effects, effect);
    }
    
    /// @desc Function Description
    /// @param {Struct.PlayerData} target Description
    static activate = function(target) {
        for (var i = 0; i < array_length(self.effects); i += 1) {
            self.effects[i].apply(new EffectApplicationArgs(target, target, "", ""));
        }
    }
    
    /// @desc Function Description
    /// @param {Struct.PlayerData} target Description
    static revoke = function(target) {
        for (var i = 0; i < array_length(self.effects); i += 1) {
            self.effects[i].remove(target);
        }
    }
    
    static to_string = function() {
        var str = self.duration > 0 
            ? $"[b]When used, for the next {self.duration} battle{self.duration > 1 ? "s" : ""}:[/b]"
            : "[b]When used:[/b]";
        for (var i = 0; i < array_length(self.effects); i += 1) {
            str += $"\n  {self.effects[i].to_string(new EffectApplicationArgs(obj_player_state.data, obj_player_state.data))}";
        }
        
        return str;
    }
}