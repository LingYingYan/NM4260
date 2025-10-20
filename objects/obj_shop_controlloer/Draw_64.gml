var btn_x = 40;
var btn_y = 40;
var btn_w = 120;
var btn_h = 50;

draw_set_color(c_black);
draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);

// label
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(btn_x + btn_w/2, btn_y + btn_h/2, "Back");
