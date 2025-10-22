if (!place_meeting(mouse_x, mouse_y, self.id)) {
    exit;
}

var status = make_status(self.status_type, self.status_level)
draw_tooltip($"{status.get_label()}\n{project_status_effect(self.status_type, self.status_level)}")