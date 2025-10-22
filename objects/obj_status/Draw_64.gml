if (!point_in_rectangle(mouse_x, mouse_y, self.bbox_left, self.bbox_top, self.bbox_right, self.bbox_bottom)) {
    exit;
}

var status = make_status(self.status_type, self.status_level)
draw_tooltip($"{status.get_label()}\n{project_status_effect(self.status_type, self.status_level)}")