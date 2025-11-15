if (point_in_rectangle(mouse_x, mouse_y, x - button_w/2, y - button_h / 2, x + button_w, y + button_h)) {
	self.hovered = true;
} else {
	self.hovered = false;
}


if (self.hovered) {
	// change the cursor
	window_set_cursor(cr_handpoint);
} else {
	window_set_cursor(cr_default);
}