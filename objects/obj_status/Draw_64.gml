if (mouse_x <= self.bbox_left || mouse_x >= self.bbox_right || mouse_y >= self.bbox_bottom || mouse_y <= self.bbox_top) {
    exit;
}

var mouse_x_gui = device_mouse_x_to_gui(0);
var mouse_y_gui = device_mouse_y_to_gui(0);
var x_gui = mouse_x_gui;
var y_gui = mouse_y_gui;
var status = make_status(self.status_type, self.status_level)
var scribble_text = scribble($"{status.get_label()}\n{project_status_effect(self.status_type, self.status_level)}").wrap(500);
if (mouse_x_gui <= display_get_gui_width() / 2) {
    //x_gui += panel_w / 2;
} else {
    x_gui -= (scribble_text.get_width() + 50);
}
    
if (mouse_y_gui <= display_get_gui_height() / 2) {
    //y_gui += panel_h / 2;
} else {
    y_gui -= (scribble_text.get_height() + 50);
}
    
draw_sprite_stretched(spr_panel, self.image_index, x_gui, y_gui, scribble_text.get_width() + 50, scribble_text.get_height() + 50);
scribble_text.draw(x_gui + 25, y_gui + 25);