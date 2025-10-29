if (!point_in_rectangle(mouse_x, mouse_y, self.x, self.y - self.scribble_text.get_height() / 2, self.x + self.scribble_text.get_width(), self.y + self.scribble_text.get_height() / 2)) {
    exit;
}

if (self.will_persist) {
    // This is already persistent, we can discard it if nothing is to be discarded yet
    if (is_undefined(obj_death_panel.to_discard)) {
        obj_death_panel.to_discard = self.data;
        self.will_persist = false;
    } 
} else {
    // This is about to be discarded, we can revert that 
    // if we can still make things persistent
    if (obj_death_panel.can_choose_persistent() && obj_death_panel.to_discard == self.data) {
        self.will_persist = true;
        obj_death_panel.to_discard = undefined;
    } 
}