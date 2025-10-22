var backdrop_depth = obj_backdrop.depth;
self.depth = backdrop_depth - 1;
var selected = [];
for (var i = 0; i < 3; i += 1) {
    var random_card = res_loader_cards.get_random_card("Cards");
    while (array_contains(selected, random_card.card_data.uid)) {
        instance_destroy(random_card);
        random_card = res_loader_cards.get_random_card("Cards");
    } 
            
    array_push(selected, random_card.card_data.uid);
    var card_x = room_width / 2 + (i - 1) * 2 * random_card.sprite_width;
    var new_card = instance_create_layer(card_x, room_height / 2, "Instances", obj_pickup_card);
    new_card.depth = self.depth - 1;
    new_card.card_data = random_card.card_data;
    new_card.set_reveal(obj_player_state.data.max_vision, undefined, undefined);

    new_card.on_click = function() {
        var roll = irandom_range(1, 100);
        if (roll <= 25) {
            instance_create_depth(self.x, self.y, self.depth, obj_trait_loot);
            instance_destroy(obj_card_loot);
        } else {
            obj_room_manager.goto_map();
        }
    }
}