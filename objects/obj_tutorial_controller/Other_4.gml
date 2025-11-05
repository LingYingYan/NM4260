if (global.map_inited) {
	// room-gird already set
	generate_from_grid();
	show_debug_message("generating tutorial map from the grid");
} else {
	create_tutorial_map();
	show_debug_message("creating tutorial map")

	create_tutorial_player();
	show_debug_message("creating tutorial player");
	global.map_inited = true;
}