if (is_pressing) {
    press_time++;

    // if player still pressing, and threshold reached
    if (press_time >= long_press_threshold && !long_press_done) {
        long_press_done = true;
        is_pressing = false;
		
		perm_revealed = true;

        if (is_struct(self.data) && self.data.revealed == true) {
			//save to permanently reviewed rooms, only room types
			array_push(global.perm_revealed_rooms, self.data.room_type);
			// spend 1 vision to remember the room
			obj_player_state.data.vision -= 1;
            show_debug_message($"{self.data.room_type} Room  marked as revealed!");
        }
    }
}
