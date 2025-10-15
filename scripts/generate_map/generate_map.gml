function generate_map(generate_new) {
    // Clean previous rooms in THIS room
    instance_destroy(DungeonRoom);

    // Parameters (can live here or in Game Start)
    var ROOM_DENSITY = 0.75;
    var W = global.GRID_W;
    var H = global.GRID_H;
    var S = global.ROOM_SIZE;

	
	global.room_grid = array_create(H);
    for (var r = 0; r < H; r++) global.room_grid[r] = array_create(W);
    

    var all_rooms = [];

    // STEP 1: place rooms
    for (var row = 0; row < H; row++) {
        for (var col = 0; col < W; col++) {
            if (random(1) < ROOM_DENSITY) {
				var rm = new RoomData(false,false,"default",col, row);
                //var rm = instance_create_layer(col * S, row * S + S, "Instances", DungeonRoom);
                //room_neighbors_init(rm);
                global.room_grid[row][col] = rm;
				var vis = instance_create_layer(col * S, row * S, "Instances", DungeonRoom);
				vis.data = rm; // link the visual to the data struct
                array_push(all_rooms, rm);
            } else {
                global.room_grid[row][col] = noone;
            }
        }
    }

    // ensure top & bottom rows have at least one room
    function ensure_row_has_room(r, all_rooms) {
        var found = false;
        for (var c = 0; c < global.GRID_W; c++) if (global.room_grid[r][c] != noone) { found = true; break; }
        if (!found) {
            var pick = irandom(global.GRID_W - 1);
			var rm = new RoomData(false,false,"default",pick, r+1);
            //var rm = instance_create_layer(pick * global.ROOM_SIZE, r * global.ROOM_SIZE + global.ROOM_SIZE, "Instances", DungeonRoom);
            //rm.grid_x = pick;
            //rm.grid_y = r;
            //room_neighbors_init(rm);
            global.room_grid[r][pick] = rm;
			var vis = instance_create_layer(pick*global.ROOM_SIZE, r * global.ROOM_SIZE + global.ROOM_SIZE, "Instances", DungeonRoom);
			vis.data = rm; // link the visual to the data struct
            array_push(all_rooms, rm);
        }
    }
    ensure_row_has_room(0, all_rooms);
    ensure_row_has_room(H - 1, all_rooms);

    // STEP 2: remove isolated rooms
    for (var r = 0; r < H; r++) {
        for (var c = 0; c < W; c++) {
            var rm = global.room_grid[r][c];
            if (rm == noone) continue;

            var hasNeighbor = false;
            var dirs = [[1,0],[-1,0],[0,1],[0,-1]];
            for (var d = 0; d < 4; d++) {
                var nx = c + dirs[d][0];
                var ny = r + dirs[d][1];
                if (nx >= 0 && ny >= 0 && nx < W && ny < H) {
                    if (global.room_grid[ny][nx] != noone) { hasNeighbor = true; break; }
                }
            }
            if (!hasNeighbor) {
                instance_destroy(rm);
				
                global.room_grid[r][c] = noone;
            }
        }
    }

    // STEP 3: connect 4-dir neighbors
    for (var r = 0; r < H; r++) {
        for (var c = 0; c < W; c++) {
            var rm = global.room_grid[r][c];
            if (rm == noone) continue;
            var dirs = [[1,0],[-1,0],[0,1],[0,-1]];
            for (var d = 0; d < 4; d++) {
                var nx = c + dirs[d][0];
                var ny = r + dirs[d][1];
                if (nx < 0 || ny < 0 || nx >= W || ny >= H) continue;
                var nb = global.room_grid[ny][nx];
                if (nb != noone) add_edge(rm, nb);
            }
        }
    }

    // STEP 4: flood fill from bottom row to ensure connectivity
    function flood_fill(sx, sy) {
        var stack = [[sx, sy]];
        while (array_length(stack) > 0) {
            var pos = stack[array_length(stack)-1];
			show_debug_message($"pos is {pos}")
            array_delete(stack, array_length(stack)-1, 1);
            var cx = pos[0], cy = pos[1];
            var rm = global.room_grid[cy][cx];
            if (rm == noone || rm.visited) continue;
            rm.visited = true;
            for (var i = 0; i < array_length(rm.neighbors); i++) {
                var nb = rm.neighbors[i];
                if (!nb.visited) array_push(stack, [nb.grid_x, nb.grid_y]);
            }
        }
    }

    // reset visited
    with (DungeonRoom) visited = false;

    var start_col = -1;
    for (var c = 0; c < W; c++)
        if (global.room_grid[H - 1][c] != noone) { start_col = c; break; }
    if (start_col != -1) flood_fill(start_col, H - 1);

    // prune unvisited
    for (var r = 0; r < H; r++) {
        for (var c = 0; c < W; c++) {
            var rm = global.room_grid[r][c];
            if (rm != noone && !rm.visited) {
                instance_destroy(rm);
                global.room_grid[r][c] = noone;
            }
        }
    }

    // STEP 5: count
    var count = 0;
    for (var r = 0; r < H; r++) for (var c = 0; c < W; c++) if (global.room_grid[r][c] != noone) count++;

    return [count, global.room_grid];
}
