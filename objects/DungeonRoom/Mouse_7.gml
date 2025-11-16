if (global.player_moving || Player.moving) {
	show_debug_message("stopped triggered room entering")
	exit;
}

// Prevent move if long press was done
if (long_press_done) {
    audio_play_sound(buff, 1, false);
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
audio_play_sound(footstep, 2, false);

// unrevealed but is immediate neighbor
if (!target_room.revealed) {
    for (var i = 0; i < array_length(curr.neighbors); i++) {
        if (curr.neighbors[i] == target_room) {
            canMove = true;
            break;
        }
    }

    if (canMove) {
		
		if (player.moving) exit;
        player.path_rooms = [curr, target_room]; // one step
        player.current_target_index = 1;
		player.moving = true;
		global.player_moving = true;
        
		show_debug_message("Player is moving")
		
        global.player_current_room = target_room;
    } else {
        //show_message("Can't move — that room is not adjacent.");
		var msg = instance_create_layer(0, 0, "Instances", obj_popup_message);
		msg.message_text = scribble("Can't move. That room is not adjacent")
					.align(fa_center, fa_middle);
		msg.function_to_run = function(){};
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
            if (!rm.used && rm.room_type != "shop") {
                all_used_inside = false;
                break;
            }
        }

        if (!all_used_inside) {
			
			var msg = instance_create_layer(0, 0, "Instances", obj_popup_message);
			msg.message_text = scribble("You cannot move. Some rooms along the path are unexplored!")
					.align(fa_center, fa_middle);
			msg.function_to_run = function(){};
            //show_message("You cannot move — some rooms along the path are unexplored!");
			
			is_pressing = false;
			press_time = 0;
            exit;
        }
    }
	
    if (array_length(path) > 1) {
		
		if (player.moving) exit;
		
        player.path_rooms = path;
        player.current_target_index = 1;
		player.moving = true;
		global.player_moving = true;
        
		show_debug_message("Player is moving")

        global.player_current_room = target_room;
    } else {
        //show_message("Not Connected! Find another path.");
		
		var msg = instance_create_layer(0, 0, "Instances", obj_popup_message);
		msg.message_text = scribble("Not Connected! Find another path.")
					.align(fa_center, fa_middle);
		msg.function_to_run = function(){};
    }
}

is_pressing = false;
press_time = 0;
