draw_sprite_stretched(self.sprite_index, 0, 50, 600, 300, 50);
draw_text_color(    
    375, 600, string(self.current) + "/" + string(self.max_value),
    c_black, c_black, c_black, c_black, 1
);

if (max_value > 0) {
    self.image_xscale = self.current / self.max_value;
}