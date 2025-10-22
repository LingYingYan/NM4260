var n_orbs = ceil(self.current);
var n_solid_orbs = floor(self.current);
var scribble_text = scribble($"{string_format(self.current, 0, 2)}/{self.max_value}").starting_format("font_game_text_outlined", c_white).align(fa_left, fa_middle);
var pos_x = self.x + self.orb_radius;
repeat(n_solid_orbs) {
    pos_x += 3 * self.orb_radius;
    draw_circle_color(pos_x, self.y, self.orb_radius, c_aqua, c_black, false);
}

if (n_orbs > n_solid_orbs) {
    pos_x += 3 * self.orb_radius;
    draw_set_alpha(self.current - n_orbs);
    draw_circle_color(pos_x, self.y, self.orb_radius, c_aqua, c_black, false);
    draw_set_alpha(1);
}

repeat(floor(self.max_value - n_orbs)) {
	pos_x += 3 * self.orb_radius;
    draw_circle_color(pos_x, self.y, self.orb_radius, c_aqua, c_black, true);
}

pos_x += 2 * self.orb_radius;
scribble_text.draw(pos_x, self.y);
self.right_end = pos_x + scribble_text.get_width();