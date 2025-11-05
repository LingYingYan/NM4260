// Prevent move if long press was done
if (long_press_done) {
    long_press_done = false; // reset for next click
    is_pressing = false;
    press_time = 0;
    exit; 
}


if (!instance_exists(Player)) exit;
var player = instance_find(Player, 0);
if (player.current_room == noone) exit;

var curr = player.current_room;
var target_room = self.data;
var canMove = false;

// unrevealed but is immediate neighbor
if (!target_room.revealed) {
    for (var i = 0; i < array_length(curr.neighbors); i++) {
        if (curr.neighbors[i] == target_room) {
            canMove = true;
            break;
        }
    }

    if (canMove) {
        player.path_rooms = [curr, target_room]; // one step
        player.current_target_index = 1;
        player.moving = true;
        global.player_current_room = target_room;
    } else {
        show_message("Can't move — that room is not adjacent.");
    }
}

//revealed and connected through revealed path
else {
    var path = find_path_to_room(curr, target_room);
    show_debug_message($"Target room: {target_room.grid_x},{target_room.grid_y}, Path length: {array_length(path)}");

	// check if all rooms on the path is used
	if (array_length(path) > 2) {
        var all_used_inside = true;

        for (var i = 1; i < array_length(path) - 1; i++) { // skip start room and final room
            var rm = path[i];
            if (!rm.used) {
                all_used_inside = false;
                break;
            }
        }

        if (!all_used_inside) {
            show_message("You cannot move — some rooms along the path are unexplored!");
			is_pressing = false;
			press_time = 0;
            exit;
        }
    }
	
    if (array_length(path) > 1) {
        player.path_rooms = path;
        player.current_target_index = 1;
        player.moving = true;
        global.player_current_room = target_room;
    } else {
        show_message("Not Connected! Find another path.");
    }
}

is_pressing = false;
press_time = 0;

//if (!instance_exists(Player)) exit;
//var player = instance_find(Player, 0);
////show_debug_message($"current room {player.current_room}")

//if (player.current_room != noone) {
//    var canMove = false;
//	var curr = player.current_room;
	
//	if (!revealed) {
//		for (var i = 0; i < array_length(curr.neighbors); i++) {
//	        if (curr.neighbors[i] == self.data) {
//	            canMove = true;
//	            break;
//	        }
//	    }
		
//		if (canMove) {
//	        player.target_x = x;
//	        player.target_y = y;
//	        player.current_room = self.data;
//			player.moving = true;
//			global.player_current_room = self.data;
//		}
//	} else {

//    // check if this room is a neighbor
//		var target_room = self.data;
//		show_debug_message($"In DungeonRoom, left released target_room is {target_room.grid_x}, {target_room.grid_y}");
//		var path = find_path_to_room(curr, target_room);
    
//		if (array_length(path) > 0) {
//			// can move to the target room
//			player.path_rooms = path;
//		    player.current_target_index = 1; // index 0 = current room, 1 = next step
//		    player.moving = true;
//			global.player_current_room = self.data;

//	    } else {
//	        show_debug_message("Cannot move — not connected!");
//			show_message("Not Connected! Find another path.")
//	    }
//	}
//}


//is_pressing = false;
//press_time = 0;