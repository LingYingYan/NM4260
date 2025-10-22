self.visible = true;
draw_sprite_stretched_ext(
    self.sprite_index, self.image_index, 
    self.gui_x - self.width / 2, self.gui_y - self.height / 2, 
    self.width, self.height, self.image_blend, self.image_alpha
);

if (self.hovered && !self.is_disabled) {
    window_set_cursor(cr_handpoint);
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_color(self.gui_x, self.gui_y, self.button_text, c_white, c_white, c_white, c_white, 1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);