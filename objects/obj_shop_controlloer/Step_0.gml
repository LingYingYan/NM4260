with (obj_shop_card) {
	if (selected) {
		var price = cost;
		show_debug_message($"Spent {price} to buy the card");
		obj_player_state.data.vision -= price;
		selected = false;
		sold = true;
		obj_player_deck_manager.add(id);
	}
}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mx, my, 40, 40, 160, 90)) {
        show_debug_message("Button clicked! Going to map");
        obj_room_manager.goto_map();
    }
}
