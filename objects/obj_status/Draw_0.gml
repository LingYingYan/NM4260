if (self.status == undefined) {
    exit;
}

draw_self();
scribble(string(self.status.level))
    .starting_format("font_game_text_outlined", c_white)
    .align(fa_center, fa_middle)
    .scale(1.5)
    .draw(self.x, self.y);