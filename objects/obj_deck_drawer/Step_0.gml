var target_x = is_open ? drawer_target : room_width;
drawer_x = lerp(drawer_x, target_x, 0.2);

// for mouse scroller
scroll_target -= mouse_wheel_up() * 50;
scroll_target += mouse_wheel_down() * 50;

// for keyboard (temporary)
if (keyboard_check(vk_up))   scroll_target -= scroll_speed;
if (keyboard_check(vk_down)) scroll_target += scroll_speed;

scroll_target = clamp(scroll_target, 0, max_scroll);
scroll_y = lerp(scroll_y, scroll_target, 0.2);

with (obj_deck_drawer_card) {
    x = other.drawer_x + other.drawer_width / 2;
	y = 50 + idx * (other.card_height + other.card_spacing) - other.scroll_y;
	
	if (selected && !removed) {
		removed = true;
		// remove the card from the deck
		if (count > 1) {
			// count - 1
			count -= 1;
			
			obj_player_state.data.vision -= 0.5;
			// loop through player deck and remove the card instance
			//var card_id = card_data.uid;
			obj_player_deck_manager.remove_first(card_data);
		} else {
			//removed = true;
			obj_player_state.data.vision -= 0.5;
			// loop through player deck and remove the card instance
			//var card_id = card_data.uid;
			obj_player_deck_manager.remove_first(card_data);
			// remove the instance
			instance_destroy();
		}
		// - 0.5 vision
		
		
		show_debug_message($"Removed the card");
		
	}
}