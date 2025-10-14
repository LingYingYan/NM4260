// Inherit the parent event
event_inherited();

if (!self.grabbable && !self.selectable) {
    self.hovered = false;
}