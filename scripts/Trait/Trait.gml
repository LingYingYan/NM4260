/// @desc Function Description
/// @param {string} _id Description
/// @param {string} _name Description
/// @param {real} _rarity Description
function Trait(_id, _name, _rarity, _desc) constructor {
    uid = _id;
    name = _name;
    rarity = _rarity;
    desc = _desc;
    modifiers = [];
    
    add_modifier = function(key, magnitude) {
        array_push(self.modifiers, {
            name: key, value: magnitude
        });
    }
    
    get_weight = function() {
        return 5 - self.rarity;
    }
}

/**
 * Function Description
 * @param {Struct.PlayerData} player_data Description
 * @param {Struct.Trait} trait Description
 */
function gain_trait(player_data, trait) {
    array_push(player_data.traits, trait);
    for (var i = 0; i < array_length(trait.modifiers); i += 1) {
        var modifier_name = trait.modifiers[i].name;
        if (variable_struct_exists(player_data.modifiers, modifier_name)) {
            player_data.modifiers[$ modifier_name] += trait.modifiers[i].value;
        } else {
            player_data.modifiers[$ modifier_name] = trait.modifiers[i].value;
        }
    }
}

function initialise_traits() {
    obj_traits_manager.remaining_traits = [];
    obj_traits_manager.owned_traits = [];
    for (var i = 0; i < array_length(res_loader_traits.loaded); i += 1) {
        array_push(obj_traits_manager.remaining_traits, res_loader_traits.loaded[i]);
        obj_traits_manager.total_weight += res_loader_traits.loaded[i].get_weight();
    }
}

