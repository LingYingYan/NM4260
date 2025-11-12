var target_x = is_open ? drawer_target : room_width;
drawer_x = lerp(drawer_x, target_x, 0.2);

if (abs(drawer_x - target_x) < 1) drawer_x = target_x; // snap cleanly

var card_count = 0;
if (room == rm_shop) {
	card_count = instance_number(obj_deck_drawer_card);
} else {
	card_count = instance_number(obj_deck_viewonly_card);
}

var total_content_height = (card_height + card_spacing) * card_count;

if (total_content_height > drawer_height) {
    max_scroll = total_content_height - drawer_height;

    // Mouse scroll
    scroll_target -= mouse_wheel_up() * 50;
    scroll_target += mouse_wheel_down() * 50;

    //// Keyboard scroll (temporary)
    //if (keyboard_check(vk_up))   scroll_target -= scroll_speed;
    //if (keyboard_check(vk_down)) scroll_target += scroll_speed;

    // Clamp within range
    scroll_target = clamp(scroll_target, 0, max_scroll);
} else {
    // No need to scroll if everything fits
    scroll_target = 0;
}

scroll_y = lerp(scroll_y, scroll_target, 0.2);

if (room == rm_shop) {
	with (obj_deck_drawer_card) {
	    x = other.drawer_x + other.drawer_width / 2;
		y = 100 + idx * (other.card_height + other.card_spacing) - other.scroll_y;
	
		if (selected && !removed && other.can_remove) {
			if (obj_player_state.data.vision >= 0.5) {
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
			
				// mark the shop as used when a card is removed from the deck
				var curr = global.player_current_room;
				var used_coor = [curr.x, curr.y];
				array_push(global.used_shops, used_coor);
				show_debug_message($"The shop at {curr.x}, {curr.y} is marked as used")
			} else {
				selected = false;
				show_message("You do not have enough vision!")
				exit;
			}
		
		}
	}
} else {
	
	with (obj_deck_viewonly_card) {
    // shift offscreen fully when closed
	    var open_ratio = clamp((room_width - other.drawer_x) / other.drawer_width, 0, 1);
	    x = other.drawer_x + other.drawer_width / 2 + (1 - open_ratio) * other.drawer_width / 2;
	    y = 100 + idx * (other.card_height + other.card_spacing) - other.scroll_y;
	}

}