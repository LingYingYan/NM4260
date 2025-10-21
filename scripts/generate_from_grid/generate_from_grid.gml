function generate_from_grid(){
	
	 for (var row = 0; row < array_length(global.room_grid); row++) {
        for (var col = 0; col < array_length(global.room_grid[row]); col++) {
            var rm = global.room_grid[row][col];
            if (is_struct(rm)) {
				if (rm.room_type == "bonfire" && !global.bonfire_used) {
					rm.used = false;
				}
				if (rm.room_type == "shop" && !global.shop_used) {
					rm.used = false;
				}
                var vis = instance_create_layer(rm.x + global.map_offset_x, rm.y + global.map_offset_y, "Instances", DungeonRoom);
                vis.data = rm;
                //rm.id = vis.id; 
            }
        }
    }
	// regenerate start room
	var start = global.start_room;
	var vis_start = instance_create_layer(start.x + global.map_offset_x, start.y + global.map_offset_y, "Instances", DungeonRoom);
	vis_start.data = start;

    // Recreate the player
	if (is_struct(global.player_current_room)) {
	    // Player was in a specific room before exiting
	    target_room = global.player_current_room;
	    show_debug_message("Restoring player to previous room...");
	} else {
	    // Fallback to start room if no record found
	    target_room = global.start_room;
	    global.player_current_room = target_room;
	    show_debug_message("No previous room found — using start room.");
	}
	
	// Spawn the player instance
	var px = target_room.x;
	var py = target_room.y;
	var player_inst = instance_create_layer(px + global.map_offset_x, py + global.map_offset_y, "Instances", Player);

	player_inst.current_room = target_room;
	player_inst.prev_room = target_room;
	global.player_current_room = target_room;  // keep global in sync

	show_debug_message($"Player spawned at room ({target_room.grid_x}, {target_room.grid_y})");
//    if (variable_global_exists("player")) {
//        if (!instance_exists(global.player)) {
//            var start_room = global.start_room;
//            if (is_struct(start_room)) {
//                var px = start_room.x;
//                var py = start_room.y;
//                global.player = instance_create_layer(px, py, "Instances", Player);
//                global.player.current_room = start_room;
//                show_debug_message("Player recreated in starting room.");
//            }
//        }
//    } else {
//        var start_room = global.start_room;
//        if (is_struct(start_room)) {
//            global.player = instance_create_layer(start_room.x, start_room.y, "Instances", Player);
//            global.player.current_room = start_room;
//        }
//    }
}