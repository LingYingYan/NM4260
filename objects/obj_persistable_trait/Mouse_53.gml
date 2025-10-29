if (!point_in_rectangle(mouse_x, mouse_y, self.x, self.y - self.get_height() / 2, self.x + self.get_width(), self.y + self.get_height() / 2)) {
    exit;
}

if (self.will_persist) {
    if (self.had_been_persistent() && is_undefined(obj_death_panel.to_discard)) {
        obj_death_panel.to_discard = self.data;
        self.will_persist = false;
    } else if (!self.had_been_persistent()) {
        self.will_persist = false;
        if (obj_death_panel.new_persistent == self.data) {
            obj_death_panel.new_persistent = undefined;
        }
    }
} else {
    if (self.had_been_persistent() && obj_death_panel.can_choose_persistent()) {
        self.will_persist = true;
        if (obj_death_panel.to_discard == self.data) {
            obj_death_panel.to_discard = undefined;
        }
    } else if (!self.had_been_persistent() && obj_death_panel.can_choose_persistent()) {
        self.will_persist = true;
        obj_death_panel.new_persistent = self.data;
    }
}