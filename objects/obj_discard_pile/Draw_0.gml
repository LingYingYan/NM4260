draw_self();
draw_circle_color(self.bbox_left, self.bbox_top, 25, c_teal, c_teal, false);
scribble($"[b][c_white]{self.size()}[/c][/b]").align(fa_center, fa_middle).draw(self.bbox_left, self.bbox_top);