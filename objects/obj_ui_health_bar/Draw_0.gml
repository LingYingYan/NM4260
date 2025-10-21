if (room == rm_game_start) {
    exit;
}

draw_self();

var label_x = self.x;
var label_y = self.label_below_bar ? self.y + self.sprite_height : self.y - self.sprite_height;

scribble($"{self.current}/{self.max_value}").align(fa_center, fa_middle).draw(label_x, label_y);