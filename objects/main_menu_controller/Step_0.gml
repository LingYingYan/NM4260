hover_index = -1;
hover_help_index = -1;

if (!instance_exists(obj_tutorial_popup) && !instance_exists(obj_credits) && !instance_exists(obj_help)) {
	popup_shown = false;
}

if (!popup_shown) {
	for (var i = 0; i < array_length(buttons); i++) {
	    var bx = panel_x + (panel_w - button_width) / 2;
	    var by = panel_y + 300 + i * (button_height + button_spacing)

	    if (point_in_rectangle(mouse_x, mouse_y, bx, by, bx + button_width, by + button_height)) {
	        hover_index = i;
	        if (mouse_check_button_pressed(mb_left)) {
                audio_play_sound(button_press, 3, false, 8);
	            var action = buttons[i].action;
	            switch (action) {
	                case "new_game":
	                    instance_create_layer(room_width/2, room_height/2, "Instances", obj_tutorial_popup);
						popup_shown = true;
	                    break;
	                case "credits":
	                    // go to credits?
						instance_create_layer(room_width/2, room_height/2, "Instances", obj_credits);
						popup_shown = true;
	                    break;
	                case "quit_game":
						// quit & save game
						game_end();
	                    break;
	            }
	        }
	    }
	}

	// Help click
	var help_x = room_width/2 - string_width(help_txt)/2;
	var help_y = panel_y + panel_h - 100;
	if (point_distance(mouse_x, mouse_y, help_x, help_y) < 50 ) {
	   //go to instructions page?
		hover_help_index = 1;
		if (mouse_check_button_pressed(mb_left)) {
			instance_create_layer(room_width/2, room_height/2, "Instances", obj_help);
			popup_shown = true;
		}
	}
}
