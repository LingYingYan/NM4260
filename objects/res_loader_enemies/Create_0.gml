// Inherit the parent event
event_inherited();

enemy_configs = undefined;

loaded = [];
total_weight = 0;

read_row = function(r) {
    var enemy_id = self.read_cell(r, 0);
    var enemy_name = self.read_cell(r, 1);
    var weight = real(self.read_cell(r, 2));
    var hp = real(self.read_cell(r, 3))
    var enemy = new EnemyData(enemy_id, enemy_name, weight, hp);
    
    // Load the enemy
    self.loaded[array_length(self.loaded)] = enemy;    
    total_weight += weight;  
    
    show_debug_message($"Loaded {enemy_id}: {enemy}");
}

/**
 * @desc Create a random enemy instance based on weighted probability.
 * @return {Struct.EnemyData} description
 **/
get_random_enemy = function() {
    var select = irandom_range(1, self.total_weight);
    var cumulative = 0;
    var enemy = undefined;
    for (var i = 0; i < array_length(self.loaded); i += 1) {
        cumulative += self.loaded[i].weight;
        if (cumulative >= select) {
            enemy = self.loaded[i].clone();
            break;
        }
    }
    
    // Use the last enemy if not found
    enemy ??= array_last(self.loaded).clone();
    
    // Load cards
    var cards = self.enemy_configs[$ enemy.data.uid].cards;
    var card_ids = struct_get_names(cards);
    for (var i = 0; i < array_length(card_ids); i += 1) {
        var card = res_loader_cards.loaded_map[$ card_ids[i]];
        repeat(cards[$ card_ids[i]]) {
            array_push(enemy.data.cards, card);
        }
    }
    
    return enemy;
}
