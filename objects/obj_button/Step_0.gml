var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

self.gui_x = self.x >= 0 ? self.x : gui_width * self.left_offset / 100;
self.gui_y = self.y >= 0 ? self.y : gui_height * self.top_offset / 100;

var mouse_x_gui = device_mouse_x_to_gui(0);
var mouse_y_gui = device_mouse_y_to_gui(0);
var rect_left = self.gui_x - self.width / 2;
var rect_top = self.gui_y - self.height / 2;

if (point_in_rectangle(mouse_x_gui, mouse_y_gui, rect_left, rect_top, rect_left + self.width, rect_top + self.height)) {
    hovered = true;
} else {
    hovered = false;
}

if (self.hovered && !self.is_disabled) {
    self.image_alpha = self.normal_alpha - 0.1;
    if (mouse_check_button_pressed(mb_left)) {
        self.on_click();
        window_set_cursor(cr_default);
    }
} else {
    self.image_alpha = self.normal_alpha + 0.1;
    self.image_blend = -1;
    //window_set_cursor(cr_default);
}