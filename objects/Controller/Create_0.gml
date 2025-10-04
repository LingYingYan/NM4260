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
//		}
//	}
//}
//// remove the rooms that have no neighbours
//for (var row = 0; row < 5; row ++) {
//	for (var col = 0; col < 4; col++) {
//		var rm = room_grid[row][col];
//		if (rm != noone) {
//			// the room exists
//			var hasNeighbour = false;
			
//			var dirs = [[1,0], [-1,0], [0,1], [0,-1]]; //4 directions
//            for (var d = 0; d < array_length(dirs); d++) {
//                var nx = row + dirs[d][0];
//                var ny = col + dirs[d][1];
//                if (nx >= 0 && ny >= 0 && nx < 5 && ny < 4) {
//                    if (room_grid[nx][ny] != noone) {
//                        hasNeighbor = true;
//						show_debug_message($"The room ({row},{col}) has neighbours")
//                        break;
//                    }
//                }
//            }
			
//			if (!hasNeighbor) {
//                instance_destroy(rm);
//                room_grid[row][col] = noone;
//                show_debug_message("Removed isolated room at (" + string(row) + "," + string(col) + ")");
//            }
//		}
//	}
//}

//show_debug_message($"Total rooms left is {instance_number(DungeonRoom)}")



/// obj_map_controller: Create

// ---------------- Parameters ----------------
global.GRID_W     = 5;        // columns per floor
global.FLOORS     = 4;       // number of rows (“floors”)
var CELL       = 64;       // pixel spacing
var P_NODE     = 0.75;     // probability a slot spawns a node
var EXTRA_EDGES_PER_FLOOR = 2; // how many extra edges to try per floor (cycles)

// seed randomness so runs differ; swap to random_set_seed(12345) for reproducible runs
random_set_seed(current_time);

// -------------- Storage ---------------------
room_grid = array_create(global.FLOORS);       // room_grid[floor][col] = instance or noone
for (var f = 0; f < global.FLOORS; f++) room_grid[f] = array_create(global.GRID_W);

all_rooms = []; // flat list of every room for convenience

function _in_bounds(col, floor) {
    return col >= 0 && col < global.GRID_W && floor >= 0 && floor < global.FLOORS;
}

function _add_edge(a, b) {
    if (a == noone || b == noone || a == b) return false;

    // already connected?
    for (var i = 0; i < array_length(a.neighbors); i++)
        if (a.neighbors[i] == b) return false;

    // degree caps
    if (array_length(a.neighbors) >= a.degree_cap) return false;
    if (array_length(b.neighbors) >= b.degree_cap) return false;

    array_push(a.neighbors, b);
    array_push(b.neighbors, a);
    return true;
}

// Manhattan neighbors (same floor left/right, or adjacent floor up/down same or +/-1 column)
function _adjacent_pairs_between_floors(floorA, floorB) {
    // returns list of {a:roomA, b:roomB} that are “grid-adjacent” vertically (same col or +-1)
    var pairs = [];
    for (var c = 0; c < global.GRID_W; c++) {
        var A = room_grid[floorA][c];
        if (A == noone) continue;

        // connect mostly between consecutive floors (like StS), but permit same-col or offset +/-1
        for (var dc = -1; dc <= 1; dc++) {
            var c2 = c + dc;
            if (!_in_bounds(c2, floorB)) continue;
            var B = room_grid[floorB][c2];
            if (B != noone) array_push(pairs, { a: A, b: B });
        }
    }
    return pairs;
}

// ---------------- Step 1: spawn nodes on a “template” of floors ----------------
// (Slay the Spire uses a floor-based template then connects between floors. :contentReference[oaicite:1]{index=1})
for (var f = 0; f < global.FLOORS; f++) {
    for (var c = 0; c < global.GRID_W; c++) {
        if (random(1) < P_NODE) {
            var rx = c * CELL;
            var ry = (global.FLOORS-1 - f) * CELL; // draw bottom floor at screen bottom
            var R = instance_create_layer(rx, ry, "Instances", DungeonRoom);
            R.grid_x = c;
            R.grid_y = f;     // logical “floor”
            room_grid[f][c] = R;
            array_push(all_rooms, R);
        } else {
            room_grid[f][c] = noone;
        }
    }
}

// ensure at least one node on top & bottom floors
function _ensure_floor_has_room(f) {
    var any = false;
    for (var c = 0; c < global.GRID_W; c++) if (room_grid[f][c] != noone) { any = true; break; }
    if (!any) {
        var pick = irandom(global.GRID_W-1);
        var rx = pick * CELL;
        var ry = (global.FLOORS-1 - f) * CELL;
        var R = instance_create_layer(rx, ry, "Instances", DungeonRoom);
        R.grid_x = pick; R.grid_y = f;
        room_grid[f][pick] = R;
        array_push(all_rooms, R);
    }
}
_ensure_floor_has_room(0);
_ensure_floor_has_room(global.FLOORS-1);

// ---------------- Step 2: cull isolated singletons (no 4-neighbors at all) ----------------
for (var f = 0; f < global.FLOORS; f++) {
    for (var c = 0; c < global.GRID_W; c++) {
        var R = room_grid[f][c];
        if (R == noone) continue;

        var neighbors_exist = false;

        // same floor left/right
        if (_in_bounds(c-1, f) && room_grid[f][c-1] != noone) neighbors_exist = true;
        if (_in_bounds(c+1, f) && room_grid[f][c+1] != noone) neighbors_exist = true;

        // adjacent floors roughly above/below (same col or +/-1)
        for (var df = -1; df <= 1; df += 2) {
            var nf = f + df;
            if (!_in_bounds(c, nf)) { } else if (room_grid[nf][c] != noone) neighbors_exist = true;
            if (_in_bounds(c-1, nf) && room_grid[nf][c-1] != noone) neighbors_exist = true;
            if (_in_bounds(c+1, nf) && room_grid[nf][c+1] != noone) neighbors_exist = true;
        }

        if (!neighbors_exist) {
            // remove
            array_delete_value(all_rooms, R);
            instance_destroy(R);
            room_grid[f][c] = noone;
        }
    }
}

// If after culling a floor became empty, ensure it has a node (keeps the vertical flow)
for (var f = 0; f < global.FLOORS; f++) _ensure_floor_has_room(f);

// ---------------- Step 3: build a spanning tree (guaranteed connectivity) ----------------
// Strategy: grow upward floor-by-floor (like StS), connecting each room to at least one
// on the next floor; then union components until all are connected. (StS connects
// to “closest” rooms in the next floor; we restrict to near columns for grid feel. :contentReference[oaicite:2]{index=2})

// DSU (disjoint-set union) helpers
global.parent = ds_map_create(); // key: instance id, val: parent id
global.rank   = ds_map_create();

function _find(x) {
    var p = ds_map_find_value(global.parent, x);
    if (p != x) {
        p = _find(p);
        ds_map_replace(global.parent, x, p);
    }
    return p;
}
function _union(a, b) {
    var ra = _find(a), rb = _find(b);
    if (ra == rb) return;
    var rka = ds_map_find_value(global.rank, ra);
    var rkb = ds_map_find_value(global.rank, rb);
    if (rka < rkb) {
        ds_map_replace(global.parent, ra, rb);
    } else if (rka > rkb) {
        ds_map_replace(global.parent, rb, ra);
    } else {
        ds_map_replace(global.parent, rb, ra);
        ds_map_replace(global.rank, ra, rka + 1);
    }
}

// init DSU sets
for (var i = 0; i < array_length(all_rooms); i++) {
    var rm_id = all_rooms[i].id;
    ds_map_add(global.parent, rm_id, rm_id);
    ds_map_add(global.rank, rm_id, 0);
}

// first, “forward” connections between consecutive floors
for (var f = 0; f < global.FLOORS-1; f++) {
    var pairs = _adjacent_pairs_between_floors(f, f+1);
    // shuffle pairs to vary the spanning tree
    for (var s = array_length(pairs)-1; s > 0; s--) {
        var j = irandom(s);
        var tmp = pairs[s]; pairs[s] = pairs[j]; pairs[j] = tmp;
    }

    // greedily add edges if they help connect components
    for (var p = 0; p < array_length(pairs); p++) {
        var a = pairs[p].a, b = pairs[p].b;
        if (_find(a.id) != _find(b.id)) {
            if (_add_edge(a, b)) _union(a.id, b.id);
        }
    }

    // ensure every node on floor f has at least one upward connection if possible
    for (var c = 0; c < global.GRID_W; c++) {
        var A = room_grid[f][c];
        if (A == noone) continue;

        var has_up = false;
        for (var k = 0; k < array_length(A.neighbors); k++)
            if (A.neighbors[k].grid_y == f+1) { has_up = true; break; }

        if (!has_up) {
            // try to connect to a near column on next floor
            var columns = [c, c-1, c+1];
            for (var t = 0; t < array_length(columns) && !has_up; t++) {
                var cc = columns[t];
                if (!_in_bounds(cc, f+1)) continue;
                var B = room_grid[f+1][cc];
                if (B != noone) {
                    if (_add_edge(A, B)) {
                        _union(A.id, B.id);
                        has_up = true;
                    }
                }
            }
        }
    }
}

// if multiple components remain, connect them by nearest vertical neighbors
function _components_connected() {
    if (array_length(all_rooms) <= 1) return true;
    var root0 = _find(all_rooms[0].id);
    for (var i = 1; i < array_length(all_rooms); i++)
        if (_find(all_rooms[i].id) != root0) return false;
    return true;
}

if (!_components_connected()) {
    // brute-force: try to connect across floors where possible while respecting degree caps
    for (var f = 0; f < global.FLOORS-1 && !_components_connected(); f++) {
        var pairs = _adjacent_pairs_between_floors(f, f+1);
        // sort by vertical proximity (already adjacent) then by |column delta|
        // (simple heuristic to “nearest” in this grid sense)
        for (var p = 0; p < array_length(pairs); p++) {
            var a = pairs[p].a, b = pairs[p].b;
            // if they’re in different components, try link
            if (_find(a.id) != _find(b.id)) {
                if (_add_edge(a, b)) _union(a.id, b.id);
            }
            if (_components_connected()) break;
        }
        if (_components_connected()) break;
    }
}

// ---------------- Step 4: add extra edges to make cycles (respect degree cap) ----------------
for (var f = 0; f < global.FLOORS-1; f++) {
    var tries = EXTRA_EDGES_PER_FLOOR;
    while (tries-- > 0) {
        var pairs = _adjacent_pairs_between_floors(f, f+1);
        if (array_length(pairs) == 0) break;
        var pick = pairs[irandom(array_length(pairs)-1)];
        _add_edge(pick.a, pick.b); // harmless if degree cap or duplicate prevents it
    }
}

// also try occasional horizontal edges within same floor to create short loops
for (var f = 0; f < global.FLOORS; f++) {
    for (var c = 0; c < global.GRID_W-1; c++) {
        var A = room_grid[f][c];
        var B = room_grid[f][c+1];
        if (A != noone && B != noone) {
            if (random(1) < 0.2) _add_edge(A, B);
        }
    }
}

// after edges: remove any nodes that ended up with degree 0
for (var i = array_length(all_rooms)-1; i >= 0; i--) {
    var R = all_rooms[i];
    if (array_length(R.neighbors) == 0) {
        room_grid[R.grid_y][R.grid_x] = noone;
        array_delete(all_rooms, i, 1);
        instance_destroy(R);
    }
}

// ---------------- Step 5: choose start (bottom floor) and end (top floor) ----------------
var bottom = [], top = [];
for (var c = 0; c < global.GRID_W; c++) {
    if (room_grid[0][c] != noone)           array_push(bottom, room_grid[0][c]);
    if (room_grid[global.FLOORS-1][c] != noone)    array_push(top,  room_grid[global.FLOORS-1][c]);
}
if (array_length(bottom) == 0) {
    // fallback: pick any node from floor 0 by force
    var col = irandom(global.GRID_W-1);
    var rx = col * CELL, ry = (global.FLOORS-1 - 0) * CELL;
    var S = instance_create_layer(rx, ry, "Instances", DungeonRoom);
    S.grid_x = col; S.grid_y = 0;
    array_push(bottom, S);
    room_grid[0][col] = S;
    array_push(all_rooms, S);
}
if (array_length(top) == 0) {
    var col = irandom(global.GRID_W-1);
    var rx = col * CELL, ry = (global.FLOORS-1 - (global.FLOORS-1)) * CELL;
    var E = instance_create_layer(rx, ry, "Instances", DungeonRoom);
    E.grid_x = col; E.grid_y = global.FLOORS-1;
    array_push(top, E);
    room_grid[global.FLOORS-1][col] = E;
    array_push(all_rooms, E);
}

// mark
var start_room = bottom[irandom(array_length(bottom) - 1)];
var end_room   = top[irandom(array_length(bottom) - 1)];
start_room.room_type = "start";
end_room.room_type   = "end";

// ---------------- tidy DSU maps ----------------
ds_map_destroy(global.parent);
ds_map_destroy(global.rank);


