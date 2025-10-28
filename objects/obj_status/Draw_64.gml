if (!point_in_rectangle(mouse_x, mouse_y, self.bbox_left, self.bbox_top, self.bbox_right, self.bbox_bottom)) {
    exit;
}

draw_tooltip($"{self.status.get_label()}\n{project_status_effect(self.status.name, self.status.level)}")