goto_battle = function() {
    if (room != rm_battle) {
		trigger_room_transition(rm_battle, c_white);
        //room_goto(rm_battle);
    }
}

goto_map = function() {
    show_debug_message($"HP: {obj_player_state.data.hp}");
    if (room != Room1) {
		trigger_room_transition(Room1, c_white);
        //room_goto(Room1);
    }
}

goto_deck_selection = function() {
    if (room != rm_game_start) {
		//trigger_room_transition(rm_game_start);
        room_goto(rm_game_start);
    }
}

goto_shop = function() {
	if (room != rm_shop) {
		trigger_room_transition(rm_shop, c_white);
	}
}

goto_treasure = function() {
	if (room != rm_treasure) {
		trigger_room_transition(rm_treasure, c_white);
	}
}

goto_bonfire = function() {
	if (room != rm_bonfire) {
		trigger_room_transition(rm_bonfire, c_white);
	}
}

goto_encounter = function() {
	if (room != rm_encounter) {
		trigger_room_transition(rm_encounter, c_white);
	}
}