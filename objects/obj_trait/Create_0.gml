scribble_text = scribble($"[{sprite_get_name(self.icon)}] {self.name}")
    .starting_format("font_game_text_outlined", c_white)
    .align(fa_left, fa_middle);

get_height = function() {
    return self.scribble_text.get_height();
}

get_width = function() {
    return self.scribble_text.get_width();
}