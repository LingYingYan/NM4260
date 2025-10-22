if (mouse_x <= self.x || mouse_x >= self.right_end || mouse_y <= self.y - self.orb_radius || mouse_y >= self.y + self.orb_radius) {
    exit;
}

obj_tooltip.tooltip_text = "[b]Vision[/b]\n" + 
                           "Vison helps you foresee your enemy's cards. " + 
                           "The higher the Vision, the more information you are likely to foresee.\n\n" + 
                           "[bi]Once per turn[/bi], you may consume [b]1[/b] Vision to fully reveal a card played by the enemy.";