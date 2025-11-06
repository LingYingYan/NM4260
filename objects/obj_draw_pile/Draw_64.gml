if (position_meeting(mouse_x, mouse_y, self.id)) {
    var tooltip_text = "This is your [b]Draw Pile[/b]\n" + 
                       "At the start of every turn, [b]5[/b] cards are randomly drawn from here.\n" + 
                      $"You currently have [b]{self.size()}[/b] cards remaining in the Draw Pile.";
    draw_tooltip(tooltip_text);
} 

draw_circle_color(self.bbox_right, self.bbox_top, 25, c_teal, c_teal, false);
scribble($"[b][c_white]{self.size()}[/c][/b]").align(fa_center, fa_middle).draw(self.bbox_right, self.bbox_top);