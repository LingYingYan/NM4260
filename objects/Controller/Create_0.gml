//random_set_seed(current_time);

//var row_num = 4;
//var col_num = 5;
//var cell = 64; //width of the cell, for displaying

//room_grid = array_create(5);

//// create a grid: 4 columns, 5 rows
//for (var row = 0; row < 5; row++) {
//	room_grid[row] = array_create(4);
//	for (var col = 0; col < 4 ; col++) {
//		if (random(1) > 0.3) {
//			// 80% chance
//			var rm = instance_create_layer(row*64, col*64, "Instances", DungeonRoom);
//			show_debug_message($"room is created at row {row}, column {col}");
//			rm.x_coor = row;
//			rm.y_coor = col;
//			room_grid[row][col] = room;
//		} else {
//			room_grid[row][col] = noone;

// ------------------- Helper function -------------------
function choose_array(arr) {
    return arr[irandom(array_length(arr) - 1)];
}

random_set_seed(current_time);


function _generate_map() {
    // clear out old rooms if any
    with (DungeonRoom) instance_destroy();

    // --- PARAMETERS ---
    var ROOM_DENSITY = 0.75;
    var EXTRA_EDGES = 6;
    global.GRID_W = 5;
    global.GRID_H = 4;
    global.ROOM_SIZE = 64;

    // --- ARRAYS ---
    room_grid = array_create(global.GRID_H);
    for (var r = 0; r < global.GRID_H; r++) room_grid[r] = array_create(global.GRID_W);
    var all_rooms = [];

    // --- STEP 1: PLACE ROOMS ---
    for (var row = 0; row < global.GRID_H; row++) {
        for (var col = 0; col < global.GRID_W; col++) {
            if (random(1) < ROOM_DENSITY) {
                var rm = instance_create_layer(col * global.ROOM_SIZE, row * global.ROOM_SIZE + global.ROOM_SIZE, "Instances", DungeonRoom);
                rm.grid_x = col;
                rm.grid_y = row;
                room_grid[row][col] = rm;
                array_push(all_rooms, rm);
            } else {
                room_grid[row][col] = noone;
            }
        }
    }

    // ensure at least 1 in top & bottom rows
    function ensure_row_has_room(r) {
        var found = false;
        for (var c = 0; c < global.GRID_W; c++) if (room_grid[r][c] != noone) { found = true; break; }
        if (!found) {
            var pick = irandom(global.GRID_W - 1);
            var rm = instance_create_layer(pick * global.ROOM_SIZE, r * global.ROOM_SIZE + global.ROOM_SIZE, "Instances", DungeonRoom);
            rm.grid_x = pick;
            rm.grid_y = r;
            room_grid[r][pick] = rm;
            array_push(all_rooms, rm);
        }
    }
    ensure_row_has_room(0);
    ensure_row_has_room(global.GRID_H - 1);

    // --- STEP 2: REMOVE ISOLATED ROOMS ---
    for (var r = 0; r < global.GRID_H; r++) {
        for (var c = 0; c < global.GRID_W; c++) {
            var rm = room_grid[r][c];
            if (rm == noone) continue;

            var hasNeighbor = false;
            var dirs = [[1,0],[-1,0],[0,1],[0,-1]];
            for (var d = 0; d < array_length(dirs); d++) {
                var nx = c + dirs[d][0];
                var ny = r + dirs[d][1];
                if (nx >= 0 && ny >= 0 && nx < global.GRID_W && ny < global.GRID_H) {
                    if (room_grid[ny][nx] != noone) { hasNeighbor = true; break; }
                }
            }

            if (!hasNeighbor) {
                instance_destroy(rm);
                room_grid[r][c] = noone;
            }
        }
    }

    // --- STEP 3: CONNECT ROOMS (4-dir) ---
    function add_edge(a, b) {
        if (a == noone || b == noone || a == b) return false;
        if (array_length(a.neighbors) >= a.degree_cap) return false;
        if (array_length(b.neighbors) >= b.degree_cap) return false;
        for (var i = 0; i < array_length(a.neighbors); i++) if (a.neighbors[i] == b) return false;
        array_push(a.neighbors, b);
        array_push(b.neighbors, a);
        return true;
    }

    for (var r = 0; r < global.GRID_H; r++) {
        for (var c = 0; c < global.GRID_W; c++) {
            var rm = room_grid[r][c];
            if (rm == noone) continue;
            var dirs = [[1,0],[-1,0],[0,1],[0,-1]];
            for (var d = 0; d < array_length(dirs); d++) {
                var nx = c + dirs[d][0];
                var ny = r + dirs[d][1];
                if (nx < 0 || ny < 0 || nx >= global.GRID_W || ny >= global.GRID_H) continue;
                var nb = room_grid[ny][nx];
                if (nb != noone) add_edge(rm, nb);
            }
        }
    }

    // --- STEP 4: FLOOD FILL CONNECTIVITY CHECK ---
    function flood_fill(sx, sy) {
        var stack = [[sx, sy]];
        while (array_length(stack) > 0) {
            var pos = stack[array_length(stack)-1];
            array_delete(stack, array_length(stack)-1, 1);
            var cx = pos[0];
            var cy = pos[1];
            var rm = room_grid[cy][cx];
            if (rm == noone || rm.visited) continue;
            rm.visited = true;
            for (var i = 0; i < array_length(rm.neighbors); i++) {
                var nb = rm.neighbors[i];
                if (!nb.visited) array_push(stack, [nb.grid_x, nb.grid_y]);
            }
        }
    }

    var start_col = -1;
    for (var c = 0; c < global.GRID_W; c++)
        if (room_grid[global.GRID_H - 1][c] != noone) { start_col = c; break; }
    if (start_col != -1) flood_fill(start_col, global.GRID_H - 1);

    for (var r = 0; r < global.GRID_H; r++) {
        for (var c = 0; c < global.GRID_W; c++) {
            var rm = room_grid[r][c];
            if (rm != noone && !rm.visited) {
                instance_destroy(rm);
                room_grid[r][c] = noone;
            }
        }
    }

    // --- STEP 5: COUNT & RETURN ---
    var count = 0;
    for (var r = 0; r < global.GRID_H; r++) {
        for (var c = 0; c < global.GRID_W; c++) {
            if (room_grid[r][c] != noone) count++;
        }
    }

    return count; // total rooms in grid (excluding start/end)
}

// keep regenerating until enough rooms exist
var total_rooms = 0;
repeat (10) { // limit attempts to prevent infinite loop
    total_rooms = _generate_map();
    show_debug_message("Generated " + string(total_rooms) + " rooms");
    if (total_rooms >= 15) break;
}

// ------------- STEP 5.5: ASSIGN ROOM TYPES -----------------
var room_lst = [];
for (var r = 0; r < global.GRID_H; r++) {
    for (var c = 0; c < global.GRID_W; c++) {
        var rm = room_grid[r][c];
        if (rm != noone) {
            array_push(room_lst, rm);
        }
    }
}
 // Shuffle rooms randomly
room_lst = array_shuffle(room_lst);

// Assign Treasure Rooms
var treasure_count = 2; 
for (var i = 0; i < array_length(room_lst); i++) {
	if (i == 0) {
		room_lst[i].room_type = "bonfire";
		with (DungeonRoom) {
			update_room_icon();
			show_debug_message("icon is updated");
		}
	} else if (i < 10) {
		//10 enemy rooms
		room_lst[i].room_type = "enemy";
		with (DungeonRoom) {
			update_room_icon();
		}
		
	} else if (i >=10 && i < 12) {
		// 2 treasure rooms
		room_lst[i].room_type = "treasure";
		with (DungeonRoom) {
			update_room_icon();
		}
	} else {
		room_lst[i].room_type = "default";
		with (DungeonRoom) {
			update_room_icon();
		}
	}
}



instance_create_layer(0, 0, "Instances", FogOfWar);

// ------------------- STEP 6: ADD START & END ROOMS OUTSIDE GRID -------------------

// pick a random bottom room to connect to the start
var bottom_rooms = [];
for (var c = 0; c < global.GRID_W; c++) {
    var rm = room_grid[global.GRID_H - 1][c];
    if (rm != noone) array_push(bottom_rooms, rm);
}

if (array_length(bottom_rooms) > 0) {
    var connect_to_start = bottom_rooms[irandom(array_length(bottom_rooms) - 1)];

    // create start room one level below the grid
    start_room = instance_create_layer(connect_to_start.x, connect_to_start.y + global.ROOM_SIZE, "Instances", DungeonRoom);
    start_room.room_type = "start";
    start_room.grid_x = connect_to_start.grid_x;
    start_room.grid_y = global.GRID_H; // logically below the grid
    start_room.neighbors = [connect_to_start];
    connect_to_start.neighbors[array_length(connect_to_start.neighbors)] = start_room; // link both ways
}

// pick a random top room to connect to the end
var top_rooms = [];
for (var c = 0; c < global.GRID_W; c++) {
    var rm = room_grid[0][c];
    if (rm != noone) array_push(top_rooms, rm);
}

if (array_length(top_rooms) > 0) {
    var connect_to_end = top_rooms[irandom(array_length(top_rooms) - 1)];

    // create end room one level above the grid
    end_room = instance_create_layer(connect_to_end.x, connect_to_end.y - global.ROOM_SIZE, "Instances", DungeonRoom);
    end_room.room_type = "end";
    end_room.grid_x = connect_to_end.grid_x;
    end_room.grid_y = -1; // logically above the grid
    end_room.neighbors = [connect_to_end];
    connect_to_end.neighbors[array_length(connect_to_end.neighbors)] = end_room; // link both ways
}



// --- STEP 7: CREATE AVATAR ---
if (instance_exists(start_room)) {
    var avatar = instance_create_layer(start_room.x, start_room.y, "Instances", Player);
    avatar.current_room = start_room;
	show_debug_message($"the current avatar postion is at {avatar.x}, {avatar.y}")
}

instance_create_layer(0, 0, "FogLayer", FogOfWar);
show_debug_message("Created fog: " + string(instance_exists(FogOfWar)));
