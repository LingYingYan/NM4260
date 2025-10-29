function initialize_map(min_rooms_required, spawn_at_bonfire) {
    //if (argument_count < 1) min_rooms_required = 15;
    //if (argument_count < 2) spawn_at_bonfire = false;
	show_debug_message($"current spawn_at_bonfire is {spawn_at_bonfire}");

    var tries = 0, total_rooms = 0, res, grid;
	
	var min_num_rooms = 18;
	if (!spawn_at_bonfire) {
		// start of the game, min_num_rooms follow min_rooms_required
		min_num_rooms = min_rooms_required;
	} else {
		// resetting map, should at least have same number of rooms
		min_num_rooms = global.TOTAL_ROOM_NUM;
	}

    repeat (10) {
        res = generate_map(true); // fills global.room_grid
        total_rooms = res[0];
        if (total_rooms >= min_num_rooms) break;
        tries++;
    }
	// assign global total room numbers
	global.TOTAL_ROOM_NUM = total_rooms;

    show_debug_message("Generated " + string(total_rooms) + " rooms in " + string(tries+1) + " attempt(s)");

	if (!spawn_at_bonfire) {
		// start of the game
		 var rooms = assign_room_types_and_icons(false);
	} else {
		var rooms = assign_room_types_and_icons(true);
	}
   

    // Create start/end rooms but choose where to spawn
    connect_start_end_and_spawn_player(spawn_at_bonfire);
	
	// filter and find permanently revealed rooms
	discover_perm_revealed_rooms();

    global.map_inited = true;

    return rooms;
}
