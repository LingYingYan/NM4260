//if (mouse_check_button_pressed(mb_left)) {
//    is_open = false;
//}

if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mouse_x, mouse_y, close_x1, close_y1, close_x2, close_y2)) {
        is_open = false;
		with (obj_ele_reaction_toggle) page_open = false;
		instance_destroy();
    }
}