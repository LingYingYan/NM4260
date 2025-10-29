// Inherit the parent event
event_inherited();
data = undefined;

had_been_persistent = function() {
    if (self.data == undefined) {
        return false;
    }
    
    for (var i = 0; i < array_length(global.persistent_traits); i += 1) {
        if (global.persistent_traits[i].uid == self.data.uid) {
            return true;
        }
    }
    
    return false;
}

will_persist = self.had_been_persistent();

scribble_text = scribble($"[scale,1.5][c_white][{sprite_get_name(self.icon)}][/c] {self.name} [[{self.will_persist ? "Retained in new life" : "Lost in new life"}][/s]")
    .starting_format("font_game_text_outlined", self.will_persist ? c_maroon : c_white)
    .align(fa_left, fa_middle);



