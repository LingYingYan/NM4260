function reveal_room(rm){
    if (rm == noone) return;
    //rm.discovered = true;  // reveal this room
    //trigger_room_event(rm);
	if (is_struct(rm)) {
		if (global.is_tut == false) { // in the actual map not tutorial
	        rm.discovered = true;      // reveal logical room
			// if its a shop room
			rm.revealed = true;
			//rm.visited = true;
			rm.used = true;
		
			if (rm.room_type == "shop") {
				handle_shop_cards(rm);
			}
			//reveal neighboring rooms as well
			show_debug_message($"DEBUGG: inside reveal_room function, the room is {rm.room_type}")
			show_debug_message($"and distance between the room and start room is {find_distance_from_start(rm, global.start_room)}");
			
			reveal_neighbors(rm);

	        trigger_room_event(rm);    // trigger event using the struct
		} else {
			// in the tutorial map
			reveal_room_in_tut(rm);
			rm.discovered = true;      // reveal logical room
			// if its a shop room
			rm.revealed = true;
			//rm.visited = true;
			rm.used = true;
		
			if (rm.room_type == "shop") {
				handle_shop_cards(rm);
			}
			
			if (rm.room_type == "default") {
				//reaching the end room
				handle_end_room();
			}
			
			trigger_room_event(rm);
		}
    } else {
        show_debug_message("ERROR: no valid data struct!");
    }
}


/**
 * Triggers the room event based on room type
 */
function trigger_room_event(room) {
    switch (room.room_type) {
    	case "enemy":
            show_debug_message("Enemy room!");
			global.boss_fight = false;
            obj_room_manager.goto_battle();
			show_debug_message($"DEBUGG: The furthest differece from start room is {global.dist_start_end}");
            break;
        case "bonfire":
            show_debug_message("Bonfire room!");
			if (global.bonfire_used == false) {
				obj_room_manager.goto_bonfire();
			}		
            break;
        case "treasure":
            show_debug_message("Treasure room!");
			obj_room_manager.goto_treasure();
            break;
		case "shop":
			show_debug_message("Shop!!");
			obj_room_manager.goto_shop();
			break;
		case "encounter":
			show_debug_message("Encounter Room!");
			obj_room_manager.goto_encounter();
			break;
		case "end":
			show_debug_message("Boss Fight!");
			global.boss_fight = true;
			obj_room_manager.goto_battle();
			break;
    }
}