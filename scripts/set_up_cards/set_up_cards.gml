function find_card_slots(player_card_slots, enemy_card_slots) {
    var n = instance_number(obj_card_drop_area);
    for (var i = 0; i < n; i += 1) {
        var drop_area = instance_find(obj_card_drop_area, i);
        switch (drop_area.owner) {
        	case "Player":
                array_push(player_card_slots, drop_area);
                break;
            case "Enemy":
                array_push(enemy_card_slots, drop_area);
                break;
        }
    }
}

function reset_card_slots(player_card_slots, enemy_card_slots) {
    for (var i = 0; i < array_length(player_card_slots); i += 1) {
        if (instance_exists(player_card_slots[i].card)) {
            player_card_slots[i].card.dropped_area = noone;
        }
        
        player_card_slots[i].card = noone;
    }
    
    for (var i = 0; i < array_length(enemy_card_slots); i += 1) {
        if (instance_exists(enemy_card_slots[i].card)) {
            enemy_card_slots[i].card.dropped_area = noone;
            instance_destroy(enemy_card_slots[i].card);
        }
        
        enemy_card_slots[i].card = noone;
    }
}

function count_enabled_card_slots(card_slots) {
    var k = 0;
    for (var i = 0; i < array_length(card_slots); i += 1) {
        if (!card_slots[i].is_disabled) {
            k += 1;
        }
    }
    
    return k;
}