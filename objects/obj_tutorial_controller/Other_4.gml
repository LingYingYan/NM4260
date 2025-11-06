if (global.map_inited) {
	// room-gird already set
	generate_from_grid();
	show_debug_message($"current number of obj_player_state: {instance_number(obj_player_state)}");
} else {
	create_tutorial_map();
	show_debug_message("creating tutorial map")

	create_tutorial_player();
	show_debug_message("creating tutorial player");
	
	show_debug_message($"DEBUG: the res_loader_cards contains loaded cards {res_loader_cards.loaded_map}")
	add_predefined_cards();
	
	global.map_inited = true;
}