random_set_seed(current_time);

for (var i = 0; i < 5; i++) { //coln
    for (var j = 0; j < 4; j++) { //rows
		// find the start and end room
		if (i == 0 && j == 3) { //start room
			var start = instance_create_layer(i*64, j*64, "Instances", DungeonRoom);
			start.room_type = "start";
			show_debug_message("start room is created at:");
			start.grid_x = 0;
			start.grid_y = 0;
		} else if (i == 4 && j == 0) {//end room
			var end_room = instance_create_layer(i*64, j*64, "Instances", DungeonRoom);
			end_room.room_type = "end";
			show_debug_message("end room is created at: ");
			end_room.grid_x = 0;
			end_room.grid_y = 0;
		} else {
			//if (choose(true,false)) { // randomly decide if a room exists
	        //    var inst = instance_create_layer(i*64, j*64, "Instances", DungeonRoom);
	        //    inst.grid_x = i;
	        //    inst.grid_y = j;
			//}
			// Until we reach the goal
			//while (i < 5 && j > 0) {
			//    if (choose(true,false)) {
			//        // try move right if not at edge
			//        //if (i < 4) cx++;
			//    } else {
			//        // try move up if not at edge
			//        //if (cy > 0) cy--;
			//    }

			//    // Make sure a room exists here
			//    var r = instance_position(i*64, j*64, DungeonRoom);
			//    if (r == noone) {
			//        r = instance_create_layer(i*64, j*64, "Instances", DungeonRoom);
			//        r.grid_x = i;
			//        r.grid_y = j;
			//    }
			//}
		}
    }
}


var cx = 0; // current x (grid coord)
var cy = 3; // current y (grid coord)

// move until you reach (4,0)
while (cx < 5 || cy > 0) {
    if (choose(true,false)) {
        if (cx < 5) {
			show_debug_message($"x increase, now is {cx}");
			cx++;
		}
    } else {
        if (cy > 0) {
			show_debug_message($"y decrease, now is {cy}");
			cy--;
		}
    }
    
    var r = instance_position(cx*64, cy*64, DungeonRoom);
	show_debug_message($"current coordinate is {cx}, {cy}");
    if (r == noone) {
        r = instance_create_layer(cx*64, cy*64, "Instances", DungeonRoom);
        r.grid_x = cx;
        r.grid_y = cy;
    }
}




//should we have the exact same number of rooms for each round?


//for (var i = 0; i < 5; i++) { //coln
//    for (var j = 0; j < 4; j++) {
//		var inst = instance_create_layer(i*64, j*64, "Instances", DungeonRoom);
//		inst.grid_x = i;
//        inst.grid_y = j;
//	}
//}