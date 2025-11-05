draw_set_alpha(alpha);

draw_sprite_stretched(spr_parchment, 0, popup_x, popup_y, popup_w, popup_h);

draw_set_color(make_color_rgb(100, 60, 40));
draw_roundrect(popup_x, popup_y, popup_x + popup_w, popup_y + popup_h, false);

draw_set_font(fnt_default_large);
draw_set_color(c_black);
draw_text(close_x1 + 10, close_y1, "X");

//scribble(text_title)
//    .align(fa_center, fa_middle)
//    .scale(2)
//    .draw(popup_x + popup_w / 2, popup_y + 80);
draw_set_color(c_white);
draw_set_font(fnt_main_header);
var header_h = string_height(text_title);
draw_text(popup_x + popup_w / 4, popup_y + 80, text_title);


draw_set_font(fnt_default_large);
draw_text(popup_x + popup_w / 4, popup_y + 160 + header_h/2, text_designers);

draw_text(popup_x + popup_w / 4, popup_y + 210 + header_h/2, text_developers);

draw_text(popup_x + popup_w / 4, popup_y + 260 + header_h/2, text_artists);

draw_text(popup_x + popup_w / 4, popup_y + 310 + header_h/2, text_QA);

draw_text(popup_x + popup_w / 4, popup_y + 360 + header_h/2, text_producer);

draw_set_alpha(1);
