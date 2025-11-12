if (is_open) {
	draw_set_colour(c_white)
	draw_roundrect(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
	desc_text.draw(room_width/2, panel_y + 100);
	//draw sprite here
}
