// If the cursor is over us
if (collision_point(mouse_x, mouse_y, self, false, false) != noone) {
	self.moused = true;
} else {
	self.moused = false;
}

self.hovered = moused && obj_mouse_manager.looking_at == self.id // && (self.grabbable || self.selectable);

self.state_update();