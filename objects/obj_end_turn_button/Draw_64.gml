// Inherit the parent event
event_inherited();

draw_sprite_stretched(sprite_index, image_index, x, y, 250, 100);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = x;
var cy = y;
cx = x + 125;
cy = y + 50;

draw_text_color(cx, cy, "End Turn", c_black, c_black, c_black, c_black, 1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);