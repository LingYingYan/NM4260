// Only respond if there's an avatar in play
show_debug_message("the left press event is triggered")

is_pressing = true;
press_time = 0;
long_press_done = false;


//if (!instance_exists(Player)) exit;
//var player = instance_find(Player, 0);
////show_debug_message($"current room {player.current_room}")

//// Only allow move if this room is adjacent (connected)
//if (player.current_room != noone) {
//    var canMove = false;
//    var curr = player.current_room;

//    // check if this room is a neighbor
//    for (var i = 0; i < array_length(curr.neighbors); i++) {
//        if (curr.neighbors[i] == self.data) {
//            canMove = true;
//            break;
//        }
//    }
	
//	//show_debug_message($"CanMove is {canMove}");

//    if (canMove) {
//        player.target_x = x;
//        player.target_y = y;
//        player.current_room = self.data;
//		global.player_current_room = self.data;

//    } else {
//        show_debug_message("Cannot move — not connected!");
//		show_message("Not Connected! Find another path.")
//    }
//}
