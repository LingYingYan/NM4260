if (global.just_exited_bonfire) {
    // skip all entry triggers for one frame
    global.just_exited_bonfire = false;
    exit;
}

if (moving) {
    if (current_target_index >= 0 && current_target_index < array_length(path_rooms)) {
        var target_room = path_rooms[current_target_index];
		show_debug_message($"target room of player is at {target_room.grid_x}, {target_room.grid_y}")
        target_x = target_room.x + global.map_offset_x;
        target_y = target_room.y + global.map_offset_y;

        // Move toward the target
        if (point_distance(x, y, target_x, target_y) > move_speed) {
            var dir = point_direction(x, y, target_x, target_y);
            x += lengthdir_x(move_speed, dir);
            y += lengthdir_y(move_speed, dir);

            //// Optionally: walking animation
            //sprite_index = spr_player_walk;
            //image_speed = 0.25;
            //image_xscale = sign(lengthdir_x(1, dir));
        } else {
            // Reached current target room
            x = target_x;
            y = target_y;

            prev_room = current_room;
            current_room = target_room;

            // Reveal when stepping into an unrevealed neighbor
            if (!current_room.revealed) {
                reveal_room(current_room);
				show_debug_message($"Revealing an unrevealed room {current_room.grid_x}, {current_room.grid_y}");
            }

            current_target_index++;

            // Stop when reached destination
            if (current_target_index >= array_length(path_rooms)) {
                moving = false;
				global.player_moving = false;
                //sprite_index = spr_player_idle;
                //image_speed = 0;
            }
        }
    } else {
        moving = false;
		global.player_moving = false;
    }
} else {
    //// Idle logic
    //sprite_index = spr_player_idle;
    //image_speed = 0;
}

// Keep reveal logic (in case player moves manually)
if (x == target_x && y == target_y) {
    if (current_room != prev_room) {
        if (!current_room.discovered || !current_room.used) {
            reveal_room(current_room);
        }
        prev_room = current_room;
    }
} else {
    prev_room = noone;
}

//if (moving) {
//	if (current_target_index >= 0 && current_target_index < array_length(path_rooms)) {
//        var target_room = path_rooms[current_target_index];
//		show_debug_message($"In Player STEP event, target room is {target_room.room_type}");
//        target_x = target_room.x;
//        target_y = target_room.y;

//        // Move toward the current target room
//        if (point_distance(x, y, target_x, target_y) > move_speed) {
//            var dir = point_direction(x, y, target_x, target_y);
//            x += lengthdir_x(move_speed, dir);
//            y += lengthdir_y(move_speed, dir);

//        } else {
//            // reached current target room
//            x = target_x;
//            y = target_y;

//            prev_room = current_room;
//            current_room = target_room;

//            current_target_index++;

//            // stop if reached final room
//            if (current_target_index >= array_length(path_rooms)) {
//                moving = false;
//				show_debug_message($"Have reached the final room {path_rooms[current_target_index].room_type} ");
//            }
//        }
//    } else {
//        moving = false;
//    }
//}



////if (point_distance(x, y, target_x, target_y) > move_speed) {
////    var dir = point_direction(x, y, target_x, target_y);
////    x += lengthdir_x(move_speed, dir);
////    y += lengthdir_y(move_speed, dir);
////} else {
////    x = target_x;
////    y = target_y;
////}


//if (x == target_x && y == target_y) {
//	//show_debug_message("current_room id: " + string(current_room));
//	//show_debug_message("previous_room id: " + string(prev_room));

//    // detect room change
//    if (current_room != prev_room) {
//        // player has just entered a new room
//        if (!current_room.discovered) {
//            reveal_room(current_room);
//        }
//        else if (!current_room.used) {
//            reveal_room(current_room);
//        }
//		//show_debug_message($"TRACKING")
//        prev_room = current_room; // update memory of where we are
//    }
//} else {
//	prev_room = noone;
//}