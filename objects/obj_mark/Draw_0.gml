draw_self();
scribble(string(self.displayed_value))
    .starting_format("font_game_text_outlined", c_white)
    .align(fa_center, fa_middle)
    .scale(self.image_xscale)
    .draw(self.x, self.y);