if (position_meeting(mouse_x, mouse_y, self.id)) {
    obj_tooltip.tooltip_text = "This is your [b]Draw Pile[/b]\n" + 
                               "At the start of every turn, [b]5[/b] cards are randomly drawn from here.\n" +
                              $"You currently have [b]{self.size()}[/b] cards remaining in the Draw Pile.";
} else {
    obj_tooltip.tooltip_text = "";
}