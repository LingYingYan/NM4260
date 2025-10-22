function reset_map(min_rooms_required) {
    show_debug_message("reset_map() called");
    with (DungeonRoom) instance_destroy();
	if (variable_global_exists("room_grid") && is_array(global.room_grid)) {
        for (var row = 0; row < array_length(global.room_grid); row++) {
            for (var col = 0; col < array_length(global.room_grid[row]); col++) {
                var rm = global.room_grid[row][col];
                if (is_struct(rm)) {
                    rm.neighbors = [];
                }
            }
        }
        global.room_grid = undefined;  // clear the old grid
		show_debug_message($"after removal, room_grid is {array_length(global.room_grid)}");
    }

    // true = spawn at bonfire
    var rooms = initialize_map(18, true);
	if (instance_exists(Player) && instance_exists(global.bonfire_room)) {
        var pl = instance_find(Player, 0);
        pl.x = global.bonfire_room.x;
        pl.y = global.bonfire_room.y;
        pl.current_room = global.bonfire_room;
		global.player_current_room = global.bonfire_room;
        show_debug_message("Player repositioned to new bonfire at: " 
            + string(pl.x) + "," + string(pl.y));
    }
	return rooms;
}
