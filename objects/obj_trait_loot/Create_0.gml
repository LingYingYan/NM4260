trait = obj_traits_manager.get_random();
if (trait == undefined) {
    instance_destroy(self);
    exit;    
}

obj_confirm_button.visible = true;
obj_confirm_button.on_click = function() {
    gain_trait(obj_player_state.data, self.trait);
    obj_confirm_button.visible = false;
    instance_destroy(obj_trait_loot);
    obj_room_manager.goto_map();
}
