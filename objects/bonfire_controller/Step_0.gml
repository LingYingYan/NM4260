/// obj_menu_ui - Step Event

// Convert mouse to GUI coordinates
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

hovered_button = -1;

// Calculate button positions (same as in Draw GUI)
var btn1_x = screen_w / 2 - (btn_width / 2) - (btn_spacing / 2);
var btn2_x = screen_w / 2 + (btn_width / 2) + (btn_spacing / 2);

// Hover detection
if (point_in_rectangle(mx, my,
    btn1_x - btn_width / 2, buttons_y - btn_height / 2,
    btn1_x + btn_width / 2, buttons_y + btn_height / 2)) {
    hovered_button = 1;
}
else if (point_in_rectangle(mx, my,
    btn2_x - btn_width / 2, buttons_y - btn_height / 2,
    btn2_x + btn_width / 2, buttons_y + btn_height / 2)) {
    hovered_button = 2;
}
