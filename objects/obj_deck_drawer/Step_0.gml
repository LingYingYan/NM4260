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
	
	if (selected && !removed) show_debug_message("Triggered: " + string(id)+ ": " + string(card_data.name));
	if (selected && !removed && other.can_remove) {
		removed = true;
		other.card_to_remove = card_data;
		other.can_remove = false;
		hover_color = c_white;
		// remove the card from the deck
		if (count > 1) {
			// count - 1
			count -= 1;
		} else {
			instance_destroy();
		}
		obj_player_state.data.vision -= 0.5;
		obj_player_deck_manager.remove_first(card_data);
		other.alarm[0] = 1;
		// - 0.5 vision
		
		show_debug_message($"Curent count is {count}");
		show_debug_message($"Removed the card successfully!");
		
	}
}