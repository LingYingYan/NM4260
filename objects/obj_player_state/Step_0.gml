// Inherit the parent event
event_inherited();
self.rearrange_traits_and_relics();
self.data.vision = clamp(self.data.vision, 0, self.max_vision);
if (self.data.hp <= 0 && room == Room1) {
    self.die();
}
    
