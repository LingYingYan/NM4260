global.number_of_completed_combat = 0;
obj_player_state.reset();
obj_player_state.initialise();

if (!instance_exists(obj_toggle_deck_button)) {
	instance_create_layer(room_width - 20, room_height/2, "Instances", obj_toggle_deck_button);
}

global.timestamp = 0;
