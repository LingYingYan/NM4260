// Inherit the parent event
event_inherited();

relic_effects = { };
loaded = [];
total_weight = 0;

read_row = function(r) {
    var uid = self.read_cell(r, 0);
    var name = self.read_cell(r, 1);
    var rarity = real(read_cell(r, 2));
    var price = real(read_cell(r, 3));
    var desc = read_cell(r, 4);
    var duration = real(read_cell(r, 5));
    
    var relic = new Relic(uid, name, desc, rarity, duration);
    if (struct_exists(self.relic_effects, uid)) {
        var effects = self.relic_effects[$ uid];
        for (var i = 0; i < array_length(effects); i += 1) {
            relic.add_effect(make_effect(effects[i], undefined));    
        }    
    }
    
    array_push(self.loaded, relic);
    self.total_weight += relic.get_weight();
}

get_random = function() {
    var select = irandom_range(1, self.total_weight);
    var cumulative = 0;
    for (var i = 0; i < array_length(self.loaded); i += 1) {
        cumulative += self.loaded[i].get_weight();
        if (cumulative >= select) {
            return self.loaded[i];
        }
    }
    
    return undefined;
}