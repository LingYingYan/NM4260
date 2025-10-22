if (position_meeting(mouse_x, mouse_y, self.id)) {
    obj_tooltip.tooltip_text = "This is your [b]Discard Pile[/b]\n" + 
                               "At the end of every turn, all cards drawn for the turn goes into here." +
                               "If you draw while the Draw Pile is empty, cards in the Discard Pile will be shuffled back to the Draw Pile.\n" + 
                              $"You currently have [b]{self.size()}[/b] cards in the Discard Pile.";
} else {
    obj_tooltip.tooltip_text = "";
}