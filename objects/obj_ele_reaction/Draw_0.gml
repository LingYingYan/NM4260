
draw_set_alpha(1);
draw_set_colour(c_white)
//draw_roundrect(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
draw_sprite_stretched(spr_notice_h, 0, panel_x, panel_y, panel_w, panel_h);
desc_text.draw(room_width/2, panel_y + panel_h / 4);
//draw sprite here
//show_debug_message("the page is drawn")
	
draw_set_font(fnt_default_large);
if (closed_btn_hovered) {
	draw_set_color(c_red);
} else {
	draw_set_color(c_black);
}
draw_set_font(font_game_text);
draw_text(close_x1, close_y1, "X");
	
draw_sprite_stretched(spr_ele_reaction_diag, 0, room_width/2 - panel_w/3, panel_y + panel_h / 4, panel_w /3 * 2, panel_h * 0.5);
