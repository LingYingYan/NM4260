function choose_array(arr) {
    return arr[irandom(array_length(arr) - 1)];
}

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

function assign_room_types_and_icons(assign_existing_room_types) {
    var rooms = [];

    for (var r = 0; r < global.GRID_H; r++) {
        for (var c = 0; c < global.GRID_W; c++) {
            var rm = global.room_grid[r][c];
            if (rm != noone) array_push(rooms, rm);
        }
    }

    rooms = array_shuffle(rooms);
	
	var shop_count = 1;
	
	if (!assign_existing_room_types) {
		// assigning new room types
		for (var i = 0; i < array_length(rooms); i++) {
		    var rm = rooms[i];
    
		    // 50% chance = enemy
		    if (random(1) < 0.5) {
		        rm.room_type = "enemy";
		    } 
		    else {
		        // for the remaining 50%, Treasure : Shop : Encounter = 2 : 2 : 3
		        var r_val = random(7); // 0–7 (exclusive)
		        if (r_val < 2) {
					rm.room_type = "treasure";
					//update room_types global variable
					update_room_types_num("treasure");
				} else if (r_val < 4) {
					rm.room_type = "shop";
					rm.room_name = "shop" + string(shop_count); //naming shops shop1 and shop2
					shop_count += 1;
					update_room_types_num("shop");
				} else {
					rm.room_type = "encounter";
					update_room_types_num("encounter");
				}
		    }
    
		    with (rm) update_room_icon();
		}
	} else {
		// assign rooms based on the existing room types
		var type_keys = ds_map_keys_to_array(global.room_types);
		var idx = 0;
	    for (var i = 0; i < array_length(type_keys); i++) {
		    var type = type_keys[i];
		    var count = global.room_types[? type];

		    for (var j = 0; j < count; j++) {
		        if (idx >= array_length(rooms)) break;

		        var rm = rooms[idx];
		        rm.room_type = type;

		        if (type == "shop") {
		            rm.room_name = "shop" + string(shop_count);
		            shop_count += 1;
		        }

		        with (rm) update_room_icon();
		        idx++;
		    }
		}
		// all remaining rooms will be enemy
		for (var k = idx; k < array_length(rooms); k++) {
		    var rm = rooms[k];
		    rm.room_type = "enemy";
		    with (rm) update_room_icon();
		}
	}


    //for (var i = 0; i < array_length(rooms); i++) {
    //    var rm = rooms[i];

    //    if (i == 0) {
    //        rm.room_type = "bonfire";
	//		rm.is_bonfire_used = false;
    //        with (rm) update_room_icon();
    //    } else if (i < 3) { //
    //        rm.room_type = "treasure";
    //        with (rm) update_room_icon();
    //    } else if (i < 5) {
	//		rm.room_type = "shop";
	//		rm.room_name = "shop" + string(i-2); //naming shops shop1 and shop2
	//		with (rm) update_room_icon();
	//	} else if (i < 15) {
	//		rm.room_type = "enemy";
	//        with (rm) update_room_icon();
	//	} else if (i < 18) {
	//		rm.room_type = "encounter";
	//		with(rm) update_room_icon();
	//	} else {
    //        rm.room_type = "default";
    //        with (rm) update_room_icon();
    //    }
    //}

    return rooms; // return ordered list (rooms[0] is bonfire)
}

function update_room_types_num(room_type) {
	if (ds_map_exists(global.room_types, room_type)) {
        global.room_types[? room_type] += 1;
    } else {
        ds_map_add(global.room_types, room_type, 1);
    }
}

function update_perm_revealed_room(room_type) {
	if (ds_map_exists(global.perm_revealed_rooms, room_type)) {
        global.perm_revealed_rooms[? room_type] += 1;
    } else {
        ds_map_add(global.perm_revealed_rooms, room_type, 1);
    }
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
		var start = new RoomData(true, true, false, true, false, "start", base.x/S, base.y/S+1);
		array_push(base.neighbors, start);
		array_push(start.neighbors, base);
        global.start_room = start
		//instance_create_layer(base.x, base.y + S, "Instances", DungeonRoom);
		var vis = instance_create_layer(base.x + global.map_offset_x, base.y + S + global.map_offset_y, "Instances", DungeonRoom);
				vis.data = start;
				vis.discovered = true;
        add_edge(global.start_room, base);
    }

	
	// find the end room
	global.end_room = find_furthest_room(global.start_room);

	// Mark it as end
	if (is_struct(global.end_room)) {
	    global.end_room.room_type = "end";
	}
	
	// decide the bonfire room
	

    // Find bonfire room
    global.bonfire_room = decide_bonfire_room();
	
	if (is_struct(global.bonfire_room)) {
	    global.bonfire_room.room_type = "bonfire";
		global.bonfire_room.is_bonfire_used = false;
		
	}
	
	//show_debug_message($"the bonfire room is spawned at {global.bonfire_room.grid_x}, {global.bonfire_room.grid_y}")
	
    //with (DungeonRoom) if (room_type == "bonfire") global.bonfire_room = self.data;
	//for (var r = 0; r < global.GRID_H; r++) {
	//    for (var c = 0; c < global.GRID_W; c++) {
	//        var rm = global.room_grid[r][c];
	//        if (is_struct(rm) && rm.room_type == "bonfire") {
	//            global.bonfire_room = rm;
	//            break;
	//        }
	//    }
	//}	
	// debug chunk
	//show_debug_message(">>> DEBUG: spawn_at_bonfire=" + string(spawn_at_bonfire));
	//show_debug_message(">>> DEBUG: start_room=" + string(global.start_room));
	//show_debug_message(">>> DEBUG: bonfire_room=" + string(global.bonfire_room));


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
            var avatar = instance_create_layer(spawn_target.x + global.map_offset_x, spawn_target.y + global.map_offset_y, "Instances", Player);
            avatar.current_room = spawn_target;
			//show_debug_message($"user is newly spawned at {spawn_target}");
        }
    }

    if (!instance_exists(FogOfWar)) {
        //instance_create_layer(0, 0, "FogLayer", FogOfWar);
		show_debug_message("Creating Fog of War")
    }
}


/// @desc discover direct neighboring rooms when a new room is entered; discover rooms n vision away at a chance of 0.5; reveal discovered rooms at a chance of 0.1
function reveal_neighbors(rm) {
	var nb_lst = rm.neighbors;
	
	var discover_prob = 0.5;
	var reveal_prob = 0.1;
	
	for (i = 0; i < array_length(nb_lst); i++) {
		var nb = nb_lst[i];
		for (var row = 0; row < array_length(global.room_grid); row++) {
			for (var col = 0; col < array_length(global.room_grid[row]); col++) {
				var grid_rm = global.room_grid[row][col];
				
				if (grid_rm != noone && grid_rm.grid_x == nb.grid_x && grid_rm.grid_y == nb.grid_y) {
					// for each neighbor, mark it as discovered
					nb.discovered = true;
					grid_rm.discovered = true;
					// if it is boss fight, reveal it
					if (grid_rm.room_type == "end") {
						nb.revealed = true;
						grid_rm.revealed = true;
					}
				}
			}
		}
	}
	show_debug_message("The room's neighbors are discovered")
	
	// only reveal more if not start room
	
	if (rm.room_type == "start") {
		show_debug_message($"Current room is start room");
	} else if (rm.room_type == "bonfire" && global.bonfire_used) {
		show_debug_message($"Current room is bonfire room");
	}
	else {
		show_debug_message("Checking and discovering neighbor");
		// 50% chance discover rooms n visions away
		var n_vision = obj_player_state.data.vision;
		discover_distance_n_nb(rm, n_vision);
		show_debug_message("The further neighbours are DISCOVERED");
	
		// 10*(n+1) % chance reveal rooms n visions away
		reveal_distance_n_neighbours(n_vision);
		show_debug_message("The further neighbours are REVEALED");
	}

		
}

function discover_distance_n_nb(curr_room, n) {
	var nbs = curr_room.neighbors;
	
	// stop recursion
    if (n <= 0) return [];

    array_push(global.checked_room, curr_room);

	for (var i = 0; i < array_length(nbs); i++) {
        var nb = nbs[i];

        // skip if already checked
        if (array_get_index(global.checked_room, nb) != -1) continue;
        // record as checked
        array_push(global.checked_room, nb);
		show_debug_message($"Running discover further neighbours, room coor is grid_x (col){nb.grid_x}, grid_y (row) {nb.grid_y}");
		
		if (random(1) < 0.5) {
			// 50% chance mark it as discovered
			if (nb.grid_x >= 0 && nb.grid_x < array_length(global.room_grid[0]) &&
			nb.grid_y >= 0 && nb.grid_y < array_length(global.room_grid)) {

			var grid_rm = global.room_grid[nb.grid_y][nb.grid_x];
				if (grid_rm != noone && grid_rm.grid_x == nb.grid_x && grid_rm.grid_y == nb.grid_y) {
					show_debug_message("Discovering further neighbours")
					nb.discovered = true;
					grid_rm.discovered = true;
					global.room_grid[nb.grid_y][nb.grid_x] = grid_rm;
					discover_distance_n_nb(nb, n - 1);
				}
			}
		}
    }
}

function reveal_distance_n_neighbours(n) {
	for (i = 0; i < array_length(global.checked_room); i ++) {
		var rm = global.checked_room[i];
		// check whether the room is discovered but not reviewed
		if (rm.discovered && !rm.revealed) {
			var prob = 10 * (n+1) /100 //probability of revealing
			if (random(1) < prob) {
				var grid_rm = global.room_grid[rm.grid_y][rm.grid_x];
				if (grid_rm != noone && grid_rm.grid_x == rm.grid_x && grid_rm.grid_y == rm.grid_y) {
					show_debug_message("Revealing further neigbhors")
					rm.revealed = true;
					grid_rm.revealed = true;
					global.room_grid[rm.grid_y][rm.grid_x] = grid_rm;
				}
			}
		}
	}
}

function check_all_room_types_appear() {
	var type_list = ["shop", "treasure", "encounter", "bonfire", "enemy"];
	var existing_type = [];
	
	for (var row = 0; row < array_length(global.room_grid); row++) {
		for (var col = 0; col < array_length(global.room_grid[row]); col++) {
			var rm = global.room_grid[row][col];
			// record down all room types
			if (rm != noone) {
				array_push(existing_type, rm.room_type);
			}
		}
	}
		
	for (i = 0; i < array_length(type_list); i++) {
		var type = type_list[i];
		if (!array_contains(existing_type, type)) {
			// some room type didnt appear
			return false;
		}
	}
	return true;
}