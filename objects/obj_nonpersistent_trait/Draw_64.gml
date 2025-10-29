if (!point_in_rectangle(mouse_x, mouse_y, self.x, self.y - self.scribble_text.get_height() / 2, self.x + self.scribble_text.get_width(), self.y + self.scribble_text.get_height() / 2)) {
    window_set_cursor(cr_default);
    exit;
}

if (!self.will_persist) {
    if (is_undefined(obj_death_panel.new_persistent)) {
        window_set_cursor(cr_handpoint);
    } else {
        window_set_cursor(cr_default);
    }
} else {
    window_set_cursor(cr_handpoint);
}
