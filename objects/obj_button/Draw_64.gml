var mouse_x_gui = device_mouse_x_to_gui(0);
var mouse_y_gui = device_mouse_y_to_gui(0);
var rect_left = self.gui_x - self.width / 2;
var rect_top = self.gui_y - self.height / 2;

var hovered = point_in_rectangle(mouse_x_gui, mouse_y_gui, rect_left, rect_top, rect_left + self.width, rect_top + self.height);
if (!self.hovered && hovered && !self.is_disabled) {
    window_set_cursor(cr_handpoint);
    self.image_blend = c_gray;
    audio_play_sound(button_hover, 4, false, 8);
} else if (self.hovered && !hovered) {
    window_set_cursor(cr_default);
    self.image_blend = self.is_disabled ? c_dkgray : -1;
} 

self.hovered = !self.is_disabled && hovered;

var scribble_text = scribble(self.button_text)
    .starting_format("font_game_text_outlined", c_white)
    .scale(1.5)
    .align(fa_center, fa_middle);

var w = max(scribble_text.get_width() * 1.5, self.width);
var h = scribble_text.get_height() * 1.5;

self.gui_w = w;
self.gui_h = h;

draw_sprite_stretched_ext(
    self.sprite_index, self.image_index, 
    self.gui_x - w / 2, self.gui_y - h / 2, 
    w, h, self.image_blend, self.image_alpha
);

if (self.hovered && !self.is_disabled && mouse_check_button_pressed(mb_left)) {
    self.on_click();
    audio_play_sound(button_press, 4, false, 8);
    window_set_cursor(cr_default);
    self.image_blend = c_dkgray
}

scribble_text.draw(self.gui_x, self.gui_y);