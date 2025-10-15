/// obj_menu_ui - Global Mouse Left Pressed Event

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Calculate button positions (must match your Draw GUI and Step)
var btn1_x = screen_w / 2 - (btn_width / 2) - (btn_spacing / 2);
var btn2_x = screen_w / 2 + (btn_width / 2) + (btn_spacing / 2);

// Button 1 clicked
if (point_in_rectangle(mx, my,
    btn1_x - btn_width / 2, buttons_y - btn_height / 2,
    btn1_x + btn_width / 2, buttons_y + btn_height / 2))
{
	if (global.bonfire_used) {
        show_message("The bonfire has gone cold. It cannot be used again.");
        exit; // do nothing further
    }

    global.bonfire_used = true;

    if (instance_exists(global.bonfire_room)) {
        global.bonfire_room.is_bonfire_used = true;
    }
    show_message("You chose to rest, hp recovered, map reset");
	show_debug_message("left button is clicked");
	global.map_needs_reset = true;  // flag that next room must regenerate
	room_goto(Room1);
}

// Button 2 clicked
if (point_in_rectangle(mx, my,
    btn2_x - btn_width / 2, buttons_y - btn_height / 2,
    btn2_x + btn_width / 2, buttons_y + btn_height / 2))
{
    show_message("You chose not to rest");
	global.just_exited_bonfire = true;
	global.bonfire_used = false;
	room_goto(Room1);
}
