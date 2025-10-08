function choose_array(arr) {
    return arr[irandom(array_length(arr) - 1)];
}

function room_neighbors_init(rm) {
    rm.neighbors = [];
    rm.degree_cap = 3; 
    rm.visited = false;
}

function add_edge(a, b) {
    if (a == noone || b == noone || a == b) return false;
    // Defensive guards (prevents “not set before reading”)
    if (!variable_instance_exists(a, "neighbors")) room_neighbors_init(a);
    if (!variable_instance_exists(b, "neighbors")) room_neighbors_init(b);

    if (array_length(a.neighbors) >= a.degree_cap) return false;
    if (array_length(b.neighbors) >= b.degree_cap) return false;

    // prevent duplicates
    for (var i = 0; i < array_length(a.neighbors); i++)
        if (a.neighbors[i] == b) return false;

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


function connect_start_end_and_spawn_player(spawn_at_bonfire) {
    var S = global.ROOM_SIZE;

    // Bottom candidates for Start connection
    var bottom_rooms = [];
    for (var c = 0; c < global.GRID_W; c++) {
        var rm = global.room_grid[global.GRID_H - 1][c];
        if (rm != noone) array_push(bottom_rooms, rm);
    }

    global.start_room = noone;
    if (array_length(bottom_rooms) > 0) {
        var base = choose_array(bottom_rooms);
        global.start_room = instance_create_layer(base.x, base.y + S, "Instances", DungeonRoom);
        room_neighbors_init(global.start_room);
        global.start_room.room_type = "start";
        global.start_room.grid_x = base.grid_x;
        global.start_room.grid_y = global.GRID_H;
        add_edge(global.start_room, base);
    }

    // Top candidates for End connection
    var top_rooms = [];
    for (var c = 0; c < global.GRID_W; c++) {
        var rm2 = global.room_grid[0][c];
        if (rm2 != noone) array_push(top_rooms, rm2);
    }

    global.end_room = noone;
    if (array_length(top_rooms) > 0) {
        var base2 = choose_array(top_rooms);
        global.end_room = instance_create_layer(base2.x, base2.y - S, "Instances", DungeonRoom);
        room_neighbors_init(global.end_room);
        global.end_room.room_type = "end";
        global.end_room.grid_x = base2.grid_x;
        global.end_room.grid_y = -1;
        add_edge(global.end_room, base2);
    }

    // Find bonfire room
    global.bonfire_room = noone;
    with (DungeonRoom) if (room_type == "bonfire") global.bonfire_room = id;

    // Spawn or move player
    var spawn_target = spawn_at_bonfire ? global.bonfire_room : global.start_room;

    if (spawn_target != noone) {
        if (instance_exists(Player)) {
            with (Player) {           
				target_x = spawn_target.x;
				target_y = spawn_target.y;
				x = spawn_target.x;
                y = spawn_target.y;
                current_room = spawn_target;
            }
			show_debug_message($"glocal bonfire is at {global.bonfire_room.x}, {global.bonfire_room.y}")
			show_debug_message($"user is current at {Player.x}, {Player.y}");
        } else {
            var avatar = instance_create_layer(spawn_target.x, spawn_target.y, "Instances", Player);
            avatar.current_room = spawn_target;
			show_debug_message($"user if newly spawned at {spawn_target}");
        }
    }

    if (!instance_exists(FogOfWar)) {
        instance_create_layer(0, 0, "FogLayer", FogOfWar);
    }
}
