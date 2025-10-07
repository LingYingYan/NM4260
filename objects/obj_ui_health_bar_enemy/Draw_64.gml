draw_set_halign(fa_center);

draw_sprite_stretched(self.sprite_index, 0, 810, 100, 300, 50);
draw_text_color(    
    960, 160, string(self.current) + "/" + string(self.max_value),
    c_black, c_black, c_black, c_black, 1
);

draw_set_halign(fa_left);