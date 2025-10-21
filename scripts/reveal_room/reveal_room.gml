function reveal_room(rm){
    if (rm == noone) return;
    //rm.discovered = true;  // reveal this room
    //trigger_room_event(rm);
	if (is_struct(rm)) {
        rm.discovered = true;      // reveal logical room
		// if its a shop room
		rm.visited = true;
		rm.used = true;
		
		if (rm.room_type == "shop") {
			handle_shop_cards(rm);
		}

        trigger_room_event(rm);    // trigger event using the struct
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
            obj_room_manager.goto_battle();
            break;
        case "bonfire":
            show_debug_message("Bonfire room!");
			if (global.bonfire_used == false) {
				room_goto(rm_bonfire);
			}		
            break;
        case "treasure":
            show_debug_message("Treasure room!");
			room_goto(rm_treasure);
            break;
		case "shop":
			show_debug_message("Shop!!");
			room_goto(rm_shop);
			break;
		case "encounter":
			show_debug_message("Encounter Room!");
			room_goto(rm_encounter);
			break;
		case "end":
			show_debug_message("Boss Fight!");
			obj_room_manager.goto_battle();
			break;
    }
}