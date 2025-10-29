// Inherit the parent event
event_inherited();

if (!point_in_rectangle(mouse_x, mouse_y, self.x, self.y - self.get_height() / 2, self.x + self.get_width(), self.y + self.get_height() / 2)) {
    window_set_cursor(cr_default);
    exit;
}

if (self.will_persist) {
    if (self.had_been_persistent() && is_undefined(obj_death_panel.to_discard)) {
        window_set_cursor(cr_handpoint);
    } else if (!self.had_been_persistent()) {
        window_set_cursor(cr_handpoint);
    } else {
        window_set_cursor(cr_default);
    }
} else {
    if (self.had_been_persistent() && obj_death_panel.can_choose_persistent()) {
        window_set_cursor(cr_handpoint);
    } else if (!self.had_been_persistent() && obj_death_panel.can_choose_persistent()) {
        window_set_cursor(cr_handpoint);
    } else {
        window_set_cursor(cr_default);
    }
}