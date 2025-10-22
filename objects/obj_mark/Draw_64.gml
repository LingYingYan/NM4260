if (!point_in_rectangle(mouse_x, mouse_y, self.bbox_left, self.bbox_top, self.bbox_right, self.bbox_bottom)) {
    exit;
}

draw_tooltip($"{make_mark(self.mark_id).describe_alt(self.mark_level)}");