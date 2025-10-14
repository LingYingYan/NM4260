if (room == rm_game_start) {
    exit;
}

draw_self();

var label_x = self.x + self.sprite_width / self.image_xscale + 10;
var label_y = self.y;

put_label(
    $"{self.current}/{self.max_value}", self,
    fa_left, fa_middle, label_x, label_y, c_black
);