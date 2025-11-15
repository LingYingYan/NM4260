depth = obj_backdrop.depth - 1;

new_persistent = undefined;
to_discard = undefined;

can_choose_persistent = function() {
    var to_persist = array_length(global.persistent_traits);
    for (var i = 0; i < array_length(global.persistent_traits); i += 1) {
        if (!is_undefined(self.to_discard) && self.to_discard.uid == global.persistent_traits[i].uid) {
            to_persist -= 1;
        }
    }
    
    if (!is_undefined(self.new_persistent)) {
        to_persist += 1;
    }
    
    return to_persist < 3 && is_undefined(self.new_persistent);
}

game_summary_text = $"[b]You won![/b]\nNumber of enemies defeated: {global.number_of_completed_combat}";
game_summary = scribble(self.game_summary_text)
    .align(fa_center, fa_top);

//var main_menu = instance_create_layer(self.x, self.y - 0.2 * room_height, "Instances", obj_main_menu_button);
//main_menu.visible = true;
//main_menu.depth = self.depth -1;

obj_main_menu_button.visible = true;
obj_main_menu_button.x = room_width/2;
obj_main_menu_button.y = room_height/2;
obj_main_menu_button.button_text = "Main Menu"
obj_main_menu_button.on_click = function() {
    obj_player_state.reset();
	trigger_room_transition(rm_main_menu, c_black);
	instance_destroy(obj_toggle_deck_button);
    //if (!is_undefined(self.to_discard)) {
    //    var idx = array_get_index(global.persistent_traits, self.to_discard);
    //    array_delete(global.persistent_traits, idx, 1);
    //}
    
    //if (!is_undefined(self.new_persistent)) {
    //    array_push(global.persistent_traits, self.new_persistent);
    //}
    
//    obj_room_manager.goto_deck_selection();
}

var n_traits = array_length(obj_player_state.data.traits);

image_xscale = room_width * 0.5 / self.sprite_width;
image_yscale = room_height * 0.8 / self.sprite_height;

var curr_y = self.y - room_height * 0.3 + game_summary.get_height();