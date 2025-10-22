if (point_in_rectangle(mouse_x, mouse_y, self.x, self.x + self.get_width(), self.y - self.get_height() / 2, self.y + self.get_height() / 2)) {
    draw_tooltip(self.desc);
}