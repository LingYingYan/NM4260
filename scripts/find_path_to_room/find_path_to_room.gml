function find_path_to_room(start_room, target_room) {
    if (start_room == noone || target_room == noone) return [];
    if (start_room == target_room) return [start_room];
	// when the target room is the start room's neighbour --> 
	for (var i = 0; i < array_length(start_room.neighbors); i++) {
	    if (start_room.neighbors[i] == target_room && target_room.revealed) {
	        return [start_room, target_room];
	    }
	}

    var q = ds_queue_create();
    var visited = ds_map_create();
    var came_from = ds_map_create();

    var key_start = string(start_room.grid_x) + "_" + string(start_room.grid_y);
    ds_queue_enqueue(q, start_room);
    visited[? key_start] = true;

    var found = false;

    while (!ds_queue_empty(q)) {
        var current = ds_queue_dequeue(q);

        if (current == target_room) {
            found = true;
            break;
        }

        var neighbors = current.neighbors;
        for (var i = 0; i < array_length(neighbors); i++) {
            var nb = neighbors[i];
            if (nb != noone && nb.revealed) {
				if (nb.used || nb.room_type == "shop" || nb == target_room) { // only revealed shops or used rooms can join the queue
	                var key_nb = string(nb.grid_x) + "_" + string(nb.grid_y);
	                if (!ds_map_exists(visited, key_nb)) {
	                    ds_queue_enqueue(q, nb);
	                    visited[? key_nb] = true;
	                    came_from[? key_nb] = current;
	                }
				}
            }
        }
    }

    var path = [];

    if (found) {
        var curr = target_room;
        repeat (1000) {
            array_insert(path, 0, curr);
            if (curr == start_room) break;

            var key_curr = string(curr.grid_x) + "_" + string(curr.grid_y);
            if (!ds_map_exists(came_from, key_curr)) break;
            curr = came_from[? key_curr];
        }
		
		if (array_length(path) == 1 && path[0] == target_room) {
	        array_insert(path, 0, start_room);
	    }
    }

    ds_queue_destroy(q);
    ds_map_destroy(visited);
    ds_map_destroy(came_from);
	
	//show_debug_message($"the path is {path}");

    return path;
}