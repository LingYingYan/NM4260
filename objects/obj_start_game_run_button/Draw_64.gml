// Inherit the parent event
event_inherited();

var text_x = self.gui_x;
var text_y = self.gui_y - self.gui_h;

scribble($"[b]Pick [c_red]{10 - obj_hand.size()}[/c] more cards to start[/b]")
    .scale(1.2)
    .align(fa_center, fa_middle)
    .draw(text_x, text_y)

