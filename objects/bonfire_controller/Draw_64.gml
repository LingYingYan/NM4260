/// obj_menu_ui - Draw GUI Event

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// --- Draw main sprite ---
var sprite_x = screen_w / 2;
draw_sprite(sprite_center, 0, sprite_x, sprite_y);

// --- Calculate button positions ---
var btn1_x = screen_w / 2 - (btn_width / 2) - (btn_spacing / 2);
var btn2_x = screen_w / 2 + (btn_width / 2) + (btn_spacing / 2);

// --- Button 1 ---
if (hovered_button == 1)
    draw_set_color(c_lime);
else
    draw_set_color(c_gray);

draw_rectangle(
    btn1_x - btn_width / 2, buttons_y - btn_height / 2,
    btn1_x + btn_width / 2, buttons_y + btn_height / 2, false
);
draw_set_color(c_white);
draw_text(btn1_x, buttons_y, btn1_text);

// --- Button 2 ---
if (hovered_button == 2)
    draw_set_color(c_lime);
else
    draw_set_color(c_gray);

draw_rectangle(
    btn2_x - btn_width / 2, buttons_y - btn_height / 2,
    btn2_x + btn_width / 2, buttons_y + btn_height / 2, false
);
draw_set_color(c_white);
draw_text(btn2_x, buttons_y, btn2_text);

// --- Description ---
draw_set_color(c_white);
draw_text(screen_w / 2, desc_y, desc_text);
