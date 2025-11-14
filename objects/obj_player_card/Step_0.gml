if (global.pause || (!self.grabbable && !self.selectable)) {
    self.hovered = false;
}

// Inherit the parent event
event_inherited();

if (room == rm_battle) {
	if (self.hovered && self.grabbable) {
		self.hover_yoffset = lerp(self.hover_yoffset, -50, 0.15);
	} else {
		self.hover_yoffset = lerp(self.hover_yoffset, 0, 0.15);
	}
}
