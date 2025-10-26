
/**
 * Function Description
 * @param {string} _id Description
 * @param {string} _name Description
 * @param {string} _desc Description
 * @param {real} _rarity description
 * @param {array<Struct.Effect>} _effects description
 */
function Relic(_id, _name, _desc, _rarity, _effects = []) constructor {
    uid = _id;
    name = _name;
    desc = _desc;
    rarity = _rarity;
    effects = _effects;
    
    static get_weight = function() {
        return 5 - self.rarity;
    }
     
    static add_effect = function(effect) {
        array_push(self.effects, effect);
    }
    
    /// @desc Function Description
    /// @param {Struct.GameCharacterData} target Description
    static activate = function(target) {
        array_foreach(self.effects, method({user: target}, function(effect) {
            effect.apply(target, target);
        }));
    }
}