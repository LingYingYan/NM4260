function reveal_room(rm){
    if (rm == noone) return;
    rm.discovered = true;  // reveal this room
    trigger_room_event(rm);
}


/**
 * Triggers the room event based on room type
 * @param {id.instance} room The dungeon room
 */
function trigger_room_event(room) {
    switch (room.room_type) {
    	case "enemy":
            show_debug_message("Enemy room!");
            room_goto(rm_battle);
            break;
        case "bonfire":
            show_debug_message("Bonfire room!");
            break;
        case "treasure":
            show_debug_message("Treasure room!");
            break;
        case "merchant":
            show_debug_message("Merchant room!");
            break;
        case "encounter":
            show_debug_message("Encounter room!");
            break;
    }
}