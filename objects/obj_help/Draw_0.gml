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
var header_w = string_width(text_title);
draw_text(popup_x + popup_w / 2 - header_w/2, popup_y + 40, text_title);


draw_set_font(fnt_default_large);
text_help.draw(popup_x + popup_w /2 , popup_y + 60 + popup_h / 2);
//draw_text_ext(popup_x + 40, popup_y + 140, text_help, 30, 720);
draw_set_alpha(1);
