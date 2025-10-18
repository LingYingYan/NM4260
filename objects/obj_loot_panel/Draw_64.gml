if (!self.visible) {
    // exit;
}

var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

var center_x = gui_width / 2;
var center_y = gui_height / 2;

draw_sprite_stretched(
    self.sprite_index, self.image_index, 
    center_x - self.width / 2, center_y - self.height / 2, 
    self.width, self.height
);
