if (!point_in_rectangle(mouse_x, mouse_y, self.x, self.y - self.scribble_text.get_height() / 2, self.x + self.scribble_text.get_width(), self.y + self.scribble_text.get_height() / 2)) {
    exit;
}

if (!self.will_persist) {
    if (is_undefined(obj_death_panel.new_persistent) && obj_death_panel.can_choose_persistent()) {
        obj_death_panel.new_persistent = self.data;
        self.will_persist = true;
    } 
} else {
    self.will_persist = false;
    if (obj_death_panel.new_persistent == self.data) {
        obj_death_panel.new_persistent = undefined;
    }
}