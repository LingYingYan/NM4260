// Inherit the parent event
event_inherited();

enemy_configs = undefined;

loaded = [[], [], []];
total_weight = [0, 0, 0];
loaded_boss = [[], [], []];
enemies = {}

read_row = function(r) {
    var enemy_id = self.read_cell(r, 0);
    var enemy_name = self.read_cell(r, 1);
    var weight = real(self.read_cell(r, 2));
    var hp = real(self.read_cell(r, 3));
    var enemy = new EnemyData(enemy_id, enemy_name, weight, hp);
    
    var level = real(self.read_cell(r, 5));
    var is_boss = bool(self.read_cell(r, 4));
    
    // Load the enemy
    if (is_boss) {
        array_push(self.loaded_boss[level - 1], enemy);    
    } else {
        array_push(self.loaded[level - 1], enemy);
    }
    
    self.enemies[$ enemy_id] = enemy;
    
    self.total_weight[level - 1] += weight;
    show_debug_message($"Loaded {enemy_id}: {enemy}");
}

get_random_boss = function(level = 1) {
    var len = array_length(self.loaded_boss[level - 1]);
    var idx = irandom_range(0, len - 1);
    return self.loaded_boss[level - 1][idx];
}

get_enemy_by_id = function(enemy_id) {
    var enemy = self.enemies[$ enemy_id];
    var cards = self.enemy_configs[$ enemy_id].cards;
    var card_ids = struct_get_names(cards);
    for (var i = 0; i < array_length(card_ids); i += 1) {
        var card = res_loader_cards.loaded_map[$ card_ids[i]];
        repeat(cards[$ card_ids[i]][$ "count"] ?? 1) {
            array_push(enemy.cards, {
                data: card,
                weight: cards[$ card_ids[i]][$ "weight"],
                cooldown: cards[$ card_ids[i]][$ "cooldown"] 
            });
        }
    }
    
    return enemy;
}

/**
 * @desc Create a random enemy instance based on weighted probability.
 * @param {real} [level]=1 1-based level index
 * @return {Struct.EnemyData} description
 **/
get_random_enemy = function(level = 1) {
    var select = irandom_range(1, self.total_weight[level - 1]);
    var cumulative = 0;
    var enemy = undefined;
    for (var i = 0; i < array_length(self.loaded[level - 1]); i += 1) {
        cumulative += self.loaded[level - 1][i].weight;
        if (cumulative >= select) {
            enemy = self.loaded[level - 1][i].clone();
            break;
        }
    }
    
    // Use the last enemy if not found
    enemy ??= array_last(self.loaded[level - 1]).clone();
    
    // Load cards
    var cards = self.enemy_configs[$ enemy.uid].cards;
    var card_ids = struct_get_names(cards);
    for (var i = 0; i < array_length(card_ids); i += 1) {
        var card = res_loader_cards.loaded_map[$ card_ids[i]];
        repeat(cards[$ card_ids[i]][$ "count"] ?? 1) {
            array_push(enemy.cards, {
                data: card,
                weight: cards[$ card_ids[i]][$ "weight"],
                cooldown: cards[$ card_ids[i]][$ "cooldown"] 
            });
        }
    }
    
    return enemy;
}
