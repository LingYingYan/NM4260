if (!place_meeting(mouse_x, mouse_y, self.id)) {
    exit;
}

draw_tooltip($"{make_mark(self.mark_id).describe_alt(self.mark_level)}");