//if (mouse_check_button_pressed(mb_left)) {
//    is_open = false;
//}

 
if (point_in_rectangle(mouse_x, mouse_y, close_x1, close_y1, close_x2, close_y2)) {
    //is_open = false;
	closed_btn_hovered = true;
	if (mouse_check_button_pressed(mb_left)) {		
		with (obj_ele_reaction_toggle) page_open = false;
		instance_destroy();
	}
} else {
	closed_btn_hovered = false;
}