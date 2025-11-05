trait = obj_traits_manager.get_random();
if (trait == undefined || array_length(obj_player_state.data.traits) >= 5) {
    instance_destroy(self);
	if (!global.in_tut) {
		obj_room_manager.goto_map();
	} else {
		obj_room_manager.goto_tut_map();
	}
    exit;    
}

obj_confirm_button.visible = true;
obj_confirm_button.on_click = function() {
    gain_trait(obj_player_state.data, self.trait);
    obj_confirm_button.visible = false;
    instance_destroy(obj_trait_loot);
    if (!global.in_tut) {
		obj_room_manager.goto_map();
	} else {
		obj_room_manager.goto_tut_map();
	}
}
