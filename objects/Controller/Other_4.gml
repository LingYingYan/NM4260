if (global.map_needs_reset) {
    reset_map(15);
    global.map_needs_reset = false;
} else {
	generate_from_grid();
	show_debug_message($" current room grid {global.room_grid}");
}