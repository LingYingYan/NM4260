if (global.just_exited_bonfire) {
    // skip all entry triggers for one frame
    global.just_exited_bonfire = false;
    exit;
}

if (point_distance(x, y, target_x, target_y) > move_speed) {
    var dir = point_direction(x, y, target_x, target_y);
    x += lengthdir_x(move_speed, dir);
    y += lengthdir_y(move_speed, dir);
} else {
    x = target_x;
    y = target_y;
}


if (x == target_x && y == target_y) {
	//show_debug_message("current_room id: " + string(current_room));
	//show_debug_message("previous_room id: " + string(prev_room));

    // detect room change
    if (current_room != prev_room) {
        // player has just entered a new room
        if (!current_room.discovered) {
            reveal_room(current_room);
        }
        else if (!current_room.used) {
            reveal_room(current_room);
        }
		//show_debug_message($"TRACKING")
        prev_room = current_room; // update memory of where we are
    }
} else {
	prev_room = noone;
}