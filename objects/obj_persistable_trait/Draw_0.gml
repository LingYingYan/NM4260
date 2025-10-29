self.scribble_text = scribble($"[scale,1.5][c_white][{sprite_get_name(self.icon)}][/c] {self.name} [[{self.will_persist ? "Retained in new life" : "Lost in new life"}][/s]")
    .starting_format("font_game_text_outlined", self.will_persist ? c_maroon : c_white)
    .align(fa_left, fa_middle);
// Inherit the parent event
event_inherited();

