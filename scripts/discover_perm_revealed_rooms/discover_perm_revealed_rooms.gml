function discover_perm_revealed_rooms(){
	
	if (!variable_global_exists("perm_revealed_rooms")) return;

    var need = global.perm_revealed_rooms;
    var total_to_reveal = 0;

	// total rooms to reveal
    var keys = ds_map_keys_to_array(need);
    for (var i = 0; i < array_length(keys); i++) {
        total_to_reveal += need[? keys[i]];
    }

    var rooms = [];
    for (var row = 0; row < array_length(global.room_grid); row++) {
        for (var col = 0; col < array_length(global.room_grid[row]); col++) {
            var rm = global.room_grid[row][col];
            if (rm != noone) array_push(rooms, rm);
        }
    }
    rooms = array_shuffle(rooms);

    for (var r = 0; r < array_length(rooms) && total_to_reveal > 0; r++) {
        var rm = rooms[r];
        var rtype = rm.room_type;

        if (ds_map_exists(need, rtype)) {
            var remain = need[? rtype];
            if (remain > 0 && !rm.perm_revealed) {
                rm.revealed = true;
                rm.discovered = true;
                rm.perm_revealed = true;

                need[? rtype] = remain - 1;
                total_to_reveal -= 1;
            }
        }
    }
	
}