// If the cursor is over us
if (collision_point(mouse_x, mouse_y, self, false, false) != noone) {
	self.moused = true;
} else {
	self.moused = false;
}

var hovered = moused && obj_mouse_manager.looking_at == self.id // && (self.grabbable || self.selectable);
if (!self.hovered && hovered) {
    window_set_cursor(cr_handpoint);
} else if (self.hovered && !hovered) {
    window_set_cursor(cr_default);
}

self.hovered = hovered;

self.state_update();