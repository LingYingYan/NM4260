function decide_bonfire_room(){
	var start_room = global.start_room;
	var end_room = global.end_room;
    if (!is_struct(start_room) || !is_struct(end_room)) return noone;

    // find distance from start to every room
    var dist_map = ds_map_create();
    var queue = ds_queue_create();

    ds_queue_enqueue(queue, start_room);
    ds_map_add(dist_map, start_room, 0);

    var max_dist = 0;

    while (!ds_queue_empty(queue)) {
        var current = ds_queue_dequeue(queue);
        var curr_dist = dist_map[? current];

        if (curr_dist > max_dist) max_dist = curr_dist;

        for (var i = 0; i < array_length(current.neighbors); i++) {
            var nb = current.neighbors[i];
            if (!ds_map_exists(dist_map, nb)) {
                ds_map_add(dist_map, nb, curr_dist + 1);
                ds_queue_enqueue(queue, nb);
            }
        }
    }

    // find distance between start and end
    var total_dist = (ds_map_exists(dist_map, end_room)) ? dist_map[? end_room] : -1;
    if (total_dist < 0) {
        show_debug_message("End room not reachable");
        ds_map_destroy(dist_map);
        ds_queue_destroy(queue);
        return noone;
    }

    // identify rooms halfway or more between start & end
    var half_dist = floor(total_dist / 2);
    var candidates = [];

    var key_list = ds_map_keys_to_array(dist_map);
    for (var i = 0; i < array_length(key_list); i++) {
        var rm = key_list[i];
        var d = dist_map[? rm];
        // exclude start/end & prefer those around halfway point
        if (rm != start_room && rm != end_room && d >= half_dist) {
            array_push(candidates, rm);
        }
    }

    // Choose one candidate randomly (if exists) ---
    var chosen = noone;
    if (array_length(candidates) > 0) {
        chosen = choose_array(candidates);
    }

    ds_map_destroy(dist_map);
    ds_queue_destroy(queue);

    return chosen;
}