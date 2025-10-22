// Inherit the parent event
event_inherited();

if (!global.pause && self.hovered && self.reveal < obj_player_state.data.max_vision && self.can_reveal) {
    self.image_blend = c_gray;
    var tooltip_text = "[c_white][b]Reveal Card\n[c_red]-1 Vision[/b][/c]";
    var scribble_text = scribble(tooltip_text).wrap(self.sprite_width * 0.8).align(fa_center, fa_middle);
    var text_w = scribble_text.get_width() * 1.2;
    var text_h = scribble_text.get_height() * 1.2;
    draw_sprite_stretched(
        spr_reveal_tooltip, self.image_index, 
        self.x - text_w / 2, self.y - text_h / 2, text_w, text_h
    );
    
    scribble_text.draw(self.x, self.y);
    
    window_set_cursor(cr_handpoint);
} else {
    self.image_blend = -1;
    window_set_cursor(cr_default);
}