if (global.pause || (!self.grabbable && !self.selectable)) {
    self.hovered = false;
}

// Inherit the parent event
event_inherited();
