if (point_in_rectangle(mouse_x, mouse_y, self.x, self.y - self.orb_radius, self.right_end, self.y + self.orb_radius)) {
    var tooltip_text = "[b]Vision[/b]\n" + 
                       "Vison helps you foresee your enemy's cards. " + 
                       "The higher the Vision, the more information you are likely to foresee.\n\n" + 
                       "[bi]Once per turn[/bi], you may consume [b]1[/b] Vision to fully reveal a card played by the enemy.";
    draw_tooltip(tooltip_text);
}