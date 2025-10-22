if (room == rm_game_start) {
    exit;
}

draw_self();

var label_x = self.x + self.sprite_width / 2 + 10;
var label_y = self.y;
var scribble_text = scribble($"{self.current}/{self.max_value}").starting_format("font_game_text_outlined", c_white).align(fa_left, fa_middle);
scribble_text.draw(label_x, label_y);