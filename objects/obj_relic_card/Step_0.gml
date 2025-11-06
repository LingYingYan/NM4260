event_inherited();


if (room == rm_shop) {
	if (self.hovered) {
	    self.hover_scale = lerp(self.hover_scale, 1.1, 0.15); // grow smoothly
	} else {
	    self.hover_scale = lerp(self.hover_scale, 1.0, 0.15); // shrink smoothly
	}
	//self.image_xscale = self.hover_scale;
	//self.image_yscale = self.hover_scale;
} else if (room == Room1 || room == rm_tutorial) {
	if (self.hovered) {
		self.hover_yoffset = lerp(self.hover_yoffset, -50, 0.15);
	} else {
		self.hover_yoffset = lerp(self.hover_yoffset, 0, 0.15);
	}
}

//self.image_xscale = self.hover_scale;
//self.image_yscale = self.hover_scale;