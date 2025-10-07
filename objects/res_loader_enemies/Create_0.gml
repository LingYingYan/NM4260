// Inherit the parent event
event_inherited();

loaded = [];
total_weight = 0;

read_row = function(r) {
    var enemy_id = self.read_cell(r, 0);
    var enemy_name = self.read_cell(r, 1);
    var weight = real(self.read_cell(r, 2));
    var hp = real(self.read_cell(r, 3))
    var enemy = new EnemyData(enemy_id, enemy_name, weight, hp);
    for (var c = 4; c < ds_grid_width(self.__private.grid); c += 2) {
        var card_id = self.read_cell(r, c);
        var trimmed = string_trim(card_id);
        if (trimmed == "") {
            break;
        }
        
        var card_count = real(self.read_cell(r, c + 1));
        enemy.add_cards(card_id, card_count);
    }
    
    self.loaded[array_length(self.loaded)] = enemy;    
    total_weight += weight;  
    
    show_debug_message($"Loaded {enemy_id}: {enemy}");
}

/**
 * @desc Create a random enemy instance based on weighted probability.
 * @param {String|id.layer} instance_layer The instance layer's name or ID.
 * @param {real} pos_x The x-coordinate of the card's initial position. Default to -999.
 * @param {real} pos_y The y-coordinate of the card's initial position. Default to -999.
 **/
get_random_enemy = function(instance_layer, pos_x = -999, pos_y = -999) {
    var select = irandom_range(1, self.total_weight);
    var cumulative = 0;
    for (var i = 0; i < array_length(self.loaded); i += 1) {
        cumulative += self.loaded[i].weight;
        if (cumulative >= select) {
            var enemy = instance_create_layer(pos_x, pos_y, instance_layer, obj_enemy);
            enemy.data = self.loaded[i].clone();
            return enemy;
        }
    }
    
    var enemy = instance_create_layer(pos_x, pos_y, instance_layer, obj_enemy);
    enemy.data = array_last(self.loaded).clone();
    return enemy;
}
