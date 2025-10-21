// Inherit the parent event
event_inherited();

loaded = [];

read_row = function(r) {
    var trait_id = read_cell(r, 0);
    var name = read_cell(r, 1);
    var rarity = real(read_cell(r, 2));
    var desc = read_cell(r, 3);
    var trait = new Trait(trait_id, name, rarity, desc);
    
    var modifiers = read_cell(r, 4);
    if (modifiers != "") {
        var tokens = string_split(modifiers, ",", true);
        for (var i = 0; i < array_length(tokens); i += 1) {
            var pair = string_split(tokens[i], ":");
            trait.add_modifier(pair[0], real(pair[1]));
        }
    }
    
    var flags = string_split(read_cell(r, 5), ",");
}

