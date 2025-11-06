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

game_summary_text = $"[b]You died.[/b]\nNumber of enemies defeated: {global.number_of_completed_combat}";
game_summary = scribble(self.game_summary_text)
    .align(fa_center, fa_top);

obj_confirm_button.visible = true;
obj_confirm_button.on_click = function() {
    if (!is_undefined(self.to_discard)) {
        var idx = array_get_index(global.persistent_traits, self.to_discard);
        array_delete(global.persistent_traits, idx, 1);
    }
    
    if (!is_undefined(self.new_persistent)) {
        array_push(global.persistent_traits, self.new_persistent);
    }
    
    obj_room_manager.goto_deck_selection();
}

var n_traits = array_length(obj_player_state.data.traits);

image_xscale = room_width * 0.5 / self.sprite_width;
image_yscale = room_height * 0.8 / self.sprite_height;

var curr_y = self.y - room_height * 0.3 + game_summary.get_height();

for (var i = 0; i < n_traits; i += 1) {
    var trait_data = obj_player_state.data.traits[i];
    var trait = array_get_index(global.persistent_traits, trait_data) >= 0
        ? instance_create_depth(self.x - 0.25 * self.sprite_width, curr_y, self.depth - 1, obj_persistent_trait)
        : instance_create_depth(self.x - 0.25 * self.sprite_width, curr_y, self.depth - 1, obj_nonpersistent_trait)
    trait.set_data(trait_data);
    curr_y += trait.scribble_text.get_height() + 25;
}