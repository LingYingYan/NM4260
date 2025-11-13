if (is_open) {
	draw_set_colour(c_white)
	//draw_roundrect(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
	draw_sprite_stretched(spr_notice_h, 0, panel_x, panel_y, panel_w, panel_h);
	desc_text.draw(room_width/2, panel_y + panel_h / 4);
	//draw sprite here
}
