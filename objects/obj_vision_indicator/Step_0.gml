if (instance_exists(obj_player_state)) {
    self.current = obj_player_state.data.vision;    
    self.max_value = obj_player_state.data.max_vision;
}

if (position_meeting(mouse_x, mouse_y, self.id)) {
    var tooltip_text = "[b]Vision[/b]\n" + 
                       "Vison helps you foresee your enemy's cards. " + 
                       "The higher the Vision, the more information you are likely to foresee.\n\n" + 
                       "[bi]Once per turn[/bi], you may consume [b]1[/b] Vision to fully reveal a card played by the enemy.";
    draw_tooltip(tooltip_text);
}
