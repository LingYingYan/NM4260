draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = x;
var cy = y;
cx = x + 125;
cy = y + 50;

draw_text_color(cx, cy, self.button_text, c_black, c_black, c_black, c_black, 1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

if (self.is_disabled) {
    image_alpha = 0.2;
} else {
    image_alpha = 1;
}