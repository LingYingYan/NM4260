// Inherit the parent event
event_inherited();
self.rearrange_traits();
self.data.vision = clamp(self.data.vision, 0, self.max_vision);
