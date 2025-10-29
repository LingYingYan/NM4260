self.text = $"[scale,1.5][c_white][spr_trait_default][/c]  {self.data == undefined ? "" : self.data.name} [[{self.will_persist ? "Retained in new life" : "Lost in new life"}][/s]";
self.scribble_text = scribble(self.text)
    .starting_format("font_game_text_outlined", self.will_persist ? c_maroon : c_white)
    .align(fa_left, fa_middle);
self.scribble_text.draw(self.x, self.y);

