function choose_array(arr) {
    return arr[irandom(array_length(arr) - 1)];
}

//function room_neighbors_init(rm) {
//    rm.neighbors = [];
//    rm.degree_cap = 3; 
//    rm.visited = false;
//}

//function add_edge(a, b) {
//    if (a == noone || b == noone || a == b) return false;
    
//    if (!variable_instance_exists(a, "neighbors")) room_neighbors_init(a);
//    if (!variable_instance_exists(b, "neighbors")) room_neighbors_init(b);

//    if (array_length(a.neighbors) >= a.degree_cap) return false;
//    if (array_length(b.neighbors) >= b.degree_cap) return false;

//    // prevent duplicates
//    for (var i = 0; i < array_length(a.neighbors); i++)
//        if (a.neighbors[i] == b) return false;

//    array_push(a.neighbors, b);
//    array_push(b.neighbors, a);
//    return true;
//}

function add_edge(a, b) {
    if (!is_struct(a) || !is_struct(b) || a == b) return false;

    if (array_length(a.neighbors) >= a.degree_cap) return false;
    if (array_length(b.neighbors) >= b.degree_cap) return false;

    // Prevent duplicate
    for (var i = 0; i < array_length(a.neighbors); i++) {
        if (a.neighbors[i] == b) return false;
    }

    array_push(a.neighbors, b);
    array_push(b.neighbors, a);
    return true;
}

function assign_room_types_and_icons() {
    var rooms = [];

    for (var r = 0; r < global.GRID_H; r++) {
        for (var c = 0; c < global.GRID_W; c++) {
            var rm = global.room_grid[r][c];
            if (rm != noone) array_push(rooms, rm);
        }
    }

    rooms = array_shuffle(rooms);

    for (var i = 0; i < array_length(rooms); i++) {
        var rm = rooms[i];

        if (i == 0) {
            rm.room_type = "bonfire";
			rm.is_bonfire_used = false;
            with (rm) update_room_icon();
        }
        else if (i < 10) {
            rm.room_type = "enemy";
            with (rm) update_room_icon();
        }
        else if (i < 12) { // 10..11
            rm.room_type = "treasure";
            with (rm) update_room_icon();
        }
        else {
            rm.room_type = "default";
            with (rm) update_room_icon();
        }
    }

    return rooms; // return ordered list (rooms[0] is bonfire)
}

function find_furthest_room(start_room) {
    if (!is_struct(start_room)) return noone;

    // Dictionary to track distance from start
    var dist_map = ds_map_create();
    var queue = ds_queue_create();

    ds_queue_enqueue(queue, start_room);
    ds_map_add(dist_map, start_room, 0);

    var furthest_room = start_room;
    var max_dist = 0;

    while (!ds_queue_empty(queue)) {
        var current = ds_queue_dequeue(queue);
        var curr_dist = dist_map[? current];

        // Update farthest
        if (curr_dist > max_dist) {
            max_dist = curr_dist;
            furthest_room = current;
        }

        // Traverse neighbors
        for (var i = 0; i < array_length(current.neighbors); i++) {
            var nb = current.neighbors[i];
            if (!ds_map_exists(dist_map, nb)) {
                ds_map_add(dist_map, nb, curr_dist + 1);
                ds_queue_enqueue(queue, nb);
            }
        }
    }

    ds_map_destroy(dist_map);
    ds_queue_destroy(queue);

    return furthest_room;
}

function connect_start_end_and_spawn_player(spawn_at_bonfire) {
    var S = global.ROOM_SIZE;
	show_debug_message($"inside connect_and_spawn_player, spawn_at_bonfire: {spawn_at_bonfire}");

    // Bottom rooms for Start connection
    var bottom_rooms = [];
    for (var c = 0; c < global.GRID_W; c++) {
        var rm = global.room_grid[global.GRID_H - 1][c];
        if (rm != noone) array_push(bottom_rooms, rm);
    }
	show_debug_message($"length of room_grid: {array_length(global.room_grid)}");
	show_debug_message($"length of bottom_rooms: {array_length(bottom_rooms)}");

    global.start_room = noone;
    if (array_length(bottom_rooms) > 0) {
        var base = choose_array(bottom_rooms);
		var start = new RoomData(true, true, "start", base.x/S, base.y/S+1);
		array_push(base.neighbors, start);
		array_push(start.neighbors, base);
        global.start_room = start
		//instance_create_layer(base.x, base.y + S, "Instances", DungeonRoom);
		var vis = instance_create_layer(base.x, base.y + S, "Instances", DungeonRoom);
				vis.data = start;
				vis.discovered = true;
        //room_neighbors_init(global.start_room);
        //global.start_room.room_type = "start";
        //global.start_room.grid_x = base.grid_x;
        //global.start_room.grid_y = global.GRID_H;
        add_edge(global.start_room, base);
    }

    // Top candidates for End connection
    //var top_rooms = [];
    //for (var c = 0; c < global.GRID_W; c++) {
    //    var rm2 = global.room_grid[0][c];
    //    if (rm2 != noone) array_push(top_rooms, rm2);
    //}

    //global.end_room = noone;
    //if (array_length(top_rooms) > 0) {
    //    var base2 = choose_array(top_rooms);
    //    global.end_room = instance_create_layer(base2.x, base2.y - S, "Instances", DungeonRoom);
    //    room_neighbors_init(global.end_room);
    //    global.end_room.room_type = "end";
    //    global.end_room.grid_x = base2.grid_x;
    //    global.end_room.grid_y = -1;
    //    add_edge(global.end_room, base2);
    //}
	
	// find the end room
	global.end_room = find_furthest_room(global.start_room);

	// Mark it as end
	if (is_struct(global.end_room)) {
	    global.end_room.room_type = "end";
	}

    // Find bonfire room
    global.bonfire_room = noone;
    //with (DungeonRoom) if (room_type == "bonfire") global.bonfire_room = self.data;
	for (var r = 0; r < global.GRID_H; r++) {
	    for (var c = 0; c < global.GRID_W; c++) {
	        var rm = global.room_grid[r][c];
	        if (is_struct(rm) && rm.room_type == "bonfire") {
	            global.bonfire_room = rm;
	            break;
	        }
	    }
	}	
	// debug chunk
	show_debug_message(">>> DEBUG: spawn_at_bonfire=" + string(spawn_at_bonfire));
	show_debug_message(">>> DEBUG: start_room=" + string(global.start_room));
	show_debug_message(">>> DEBUG: bonfire_room=" + string(global.bonfire_room));


    // Spawn or move player
    var spawn_target = spawn_at_bonfire ? global.bonfire_room : global.start_room;
	show_debug_message($"spawn_target is at {spawn_target.x}, {spawn_target.y}")

    if (spawn_target != noone) {
        if (instance_exists(Player)) {
            with (Player) {           
				target_x = spawn_target.x;
				target_y = spawn_target.y;
				x = spawn_target.x;
                y = spawn_target.y;
                current_room = spawn_target;
            }
			global.player_current_room = spawn_target;
			show_debug_message($"glocal bonfire is at {global.bonfire_room.x}, {global.bonfire_room.y}")
			show_debug_message($"user is current at {Player.x}, {Player.y}");
        } else {
            var avatar = instance_create_layer(spawn_target.x, spawn_target.y, "Instances", Player);
            avatar.current_room = spawn_target;
			show_debug_message($"user if newly spawned at {spawn_target}");
        }
    }

    if (!instance_exists(FogOfWar)) {
        //instance_create_layer(0, 0, "FogLayer", FogOfWar);
		show_debug_message("Creating Fog of War")
    }
}
