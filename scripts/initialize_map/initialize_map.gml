function initialize_map(min_rooms_required, spawn_at_bonfire) {
    //if (argument_count < 1) min_rooms_required = 15;
    //if (argument_count < 2) spawn_at_bonfire = false;
	show_debug_message($"current spawn_at_bonfire is {spawn_at_bonfire}");

    var tries = 0, total_rooms = 0, res, grid;

    repeat (10) {
        res = generate_map(true); // fills global.room_grid
        total_rooms = res[0];
        if (total_rooms >= min_rooms_required) break;
        tries++;
    }

    show_debug_message("Generated " + string(total_rooms) + " rooms in " + string(tries+1) + " attempt(s)");

    var rooms = assign_room_types_and_icons();

    // Create start/end rooms but choose where to spawn
    connect_start_end_and_spawn_player(spawn_at_bonfire);

    global.map_inited = true;

    return rooms;
}
