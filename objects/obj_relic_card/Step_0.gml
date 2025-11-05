event_inherited();

if (self.hovered) {
    self.hover_scale = lerp(self.hover_scale, 1.1, 0.15); // grow smoothly
} else {
    self.hover_scale = lerp(self.hover_scale, 1.0, 0.15); // shrink smoothly
}

self.image_xscale = self.hover_scale;
self.image_yscale = self.hover_scale;