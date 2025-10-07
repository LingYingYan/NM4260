function GameCharacterData(curr_hp, total_hp) constructor {
    hp = curr_hp;
    max_hp = total_hp;
}

function PlayerData(curr_hp, total_hp, curr_vision, total_vision) : GameCharacterData(curr_hp, total_hp) constructor {
    vision = curr_vision; 
    max_vision = total_vision;
    
    get_revelation = function() {
        return clamp(self.vision * 16 + irandom_range(0, 20), 0, 100);
    }
}

/// @desc Function Description
/// @param {string} enemy_id Description
/// @param {string} enemy_name Description
/// @param {real} enemy_weight description
function EnemyData(enemy_id, enemy_name, enemy_weight, enemy_hp) : GameCharacterData(enemy_hp, enemy_hp) constructor {
    uid = enemy_id;
    name = enemy_name;
    weight = enemy_weight;
    card_uids = [];
    cards = [];
    
    add_cards = function(card_uid, count) {
        repeat (count) {
            var size = array_length(self.card_uids);
        	self.card_uids[size] = card_uid;
        }
    }
    
    clone = function() {
        var enemy = new EnemyData(self.uid, self.name, self.weight, self.max_hp);   
        for (var i = 0; i < array_length(self.card_uids); i += 1) {
            enemy.card_uids[i] = self.card_uids[i];
            enemy.cards[i] = res_loader_cards.loaded_map[? self.card_uids[i]].clone();
        }
        
        return enemy;
    } 
}