// Inherit the parent event
data = undefined;

scribble_text = scribble("");
will_persist = false;
text = "";

set_data = function(trait) {
    self.data = trait;
    self.text = $"[scale,1.5][c_white][spr_trait_default][/c]  {self.data == undefined ? "" : self.data.name} [[{self.will_persist ? "Retained in new life" : "Lost in new life"}][/s]";
    self.scribble_text = scribble(self.text)
        .starting_format("font_game_text_outlined", self.will_persist ? c_maroon : c_white)
        .align(fa_left, fa_middle);
}

