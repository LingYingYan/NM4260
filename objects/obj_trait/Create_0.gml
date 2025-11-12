scribble_text = scribble($"[scale,0.0625][{sprite_get_name(self.icon)}][/s] {self.name}")
    .starting_format("font_game_text_outlined", c_white)
    .align(fa_left, fa_middle);

get_height = function() {
    return self.scribble_text.get_height();
}

get_width = function() {
    return self.scribble_text.get_width();
}