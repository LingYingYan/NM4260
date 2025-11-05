self.depth = obj_backdrop.depth - 1;
var selected = [];
for (var i = 0; i < 3; i += 1) {
    var random_card = res_loader_cards.get_random_card("Cards");
    while (array_contains(selected, random_card.card_data.uid)) {
        instance_destroy(random_card);
        random_card = res_loader_cards.get_random_card("Cards");
    } 
            
    array_push(selected, random_card.card_data.uid);
    var card_x = room_width / 2 + (i - 1) * 2 * random_card.sprite_width;
    var new_card = instance_create_depth(card_x, room_height / 2, self.depth - 1, obj_pickup_card);
    // new_card.depth = self.depth - 1;
    new_card.card_data = random_card.card_data;
    new_card.reveal = obj_player_state.data.max_vision;

    new_card.on_click = function() {
        if (global.has_relic) {
            instance_create_depth(self.x, self.y, self.depth, obj_relic_loot);
            instance_destroy(obj_card_loot);
        } else if (global.has_trait) {
            instance_create_depth(self.x, self.y, self.depth, obj_trait_loot);
            instance_destroy(obj_card_loot);
        } else {
            if (!global.in_tut) {
				obj_room_manager.goto_map();
			} else {
				obj_room_manager.goto_tut_map();
			}
        }
    }
}