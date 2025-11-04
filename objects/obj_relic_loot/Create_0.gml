relic = res_loader_relics.get_random();

if (relic == undefined) {
    instance_destroy(self);
    if (irandom_range(1, 100) <= 25) {
        instance_create_depth(self.x, self.y, self.depth, obj_trait_loot);
        instance_destroy(obj_relic_loot);
    } else {
        obj_room_manager.goto_map();
    }
    
    exit;    
}

card = instance_create_depth(room_width / 2, room_height / 2, self.depth - 1, obj_relic_card);
card.card_data = relic;
card.selectable = false;
card.grabbable = false;

obj_confirm_button.visible = true;
obj_confirm_button.on_click = function() {
    obj_player_deck_manager.add_relic(self.relic);
    obj_confirm_button.visible = false;
    if (irandom_range(1, 100) <= 100) {
        instance_create_depth(self.x, self.y, self.depth, obj_trait_loot);
        instance_destroy(obj_relic_loot);
        instance_destroy(obj_relic_card);
    } else {
        obj_room_manager.goto_map();
    }
}