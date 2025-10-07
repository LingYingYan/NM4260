var pos_x = 0;
repeat(floor(self.current)) {
    pos_x += 50;
    draw_circle_color(pos_x, 500, 25, c_aqua, c_black, false);
}

repeat(floor(self.max_value - floor(self.current))) {
	pos_x += 50;
    draw_circle_color(pos_x, 500, 25, c_aqua, c_black, true);
}

draw_text_color(    
    375, 500, $"Vision: {self.current}/{self.max_value}",
    c_black, c_black, c_black, c_black, 1
);