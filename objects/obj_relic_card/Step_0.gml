event_inherited();


if (room == Room1 || room == rm_tutorial) {
	// in the maps, if hovered --> move up
	//var target_y = self.y + 100;
	//var original_y = self.y;
	if (self.hovered) {
	    self.y = lerp(self.y, self.y + 100, 1); // grow smoothly
	} else {
	    self.y = lerp(self.y, self.y - 100, 1); // shrink smoothly
	}
} else if (room == rm_shop) {
	//inside shop
	if (hovered) {
	    self.hover_scale = lerp(hover_scale, 1.1, 0.15); // grow smoothly
	} else {
	    self.hover_scale = lerp(hover_scale, 1.0, 0.15); // shrink smoothly
	}
}

//self.image_xscale = self.hover_scale;
//self.image_yscale = self.hover_scale;