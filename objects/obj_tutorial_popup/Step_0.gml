if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mouse_x, mouse_y, yes_button_x1, yes_button_y1, yes_button_x2, yes_button_y2)) {
        // yes option --> go to tutorial
		var loading_tut = instance_create_layer(room_width/2, room_height/2,"Instances", obj_loading_page);
		loading_tut.text_msg = "Starting Tutorial...";
		loading_tut.next_room = rm_tutorial_start;
		global.is_tut = true;
		instance_destroy();
    } else if (point_in_rectangle(mouse_x, mouse_y, no_button_x1, no_button_y1, no_button_x2, no_button_y2)) {
		var loading_mainmap = instance_create_layer(room_width/2, room_height/2,"Instances", obj_loading_page);
		loading_mainmap.text_msg = "Entering Map...";
		loading_mainmap.next_room = rm_game_start;
		global.is_tut = false;
		instance_destroy();
	}
}