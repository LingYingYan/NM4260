draw_set_color(c_white);

draw_sprite_stretched(spr_notice_h, 0, popup_x, popup_y, popup_w, popup_h)
//draw_roundrect_ext(popup_x, popup_y, popup_x + popup_w, popup_y + popup_h, 3, 3, false);

scribble_anim_wave(5, 20, 0.02);
text.draw(popup_x + popup_w/2, popup_y + popup_h/3);

draw_roundrect_ext(yes_button_x1, yes_button_y1, yes_button_x2, yes_button_y2, 2, 2, true);
yes_option.draw(yes_button_x1 + button_width/2, yes_button_y1 + button_height/2);

draw_roundrect_ext(no_button_x1, no_button_y1, no_button_x2, no_button_y2, 2, 2, true);
no_option.draw(no_button_x1 + button_width/2, no_button_y1 + button_height/2);