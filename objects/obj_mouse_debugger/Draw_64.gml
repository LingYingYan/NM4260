/// @desc description Draw mouse coordinates top-left corner
// Get the mouse position in GUI / screen space
var mouse_x_gui = device_mouse_x_to_gui(0);
var mouse_y_gui = device_mouse_y_to_gui(0);

draw_text(10, 10, $"Mouse: ({mouse_x_gui}, {mouse_y_gui})");
