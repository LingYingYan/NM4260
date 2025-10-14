// Inherit the parent event
event_inherited();

if (self.hovered && self.reveal < obj_player_state.data.max_vision && self.can_reveal) {
    self.image_blend = c_gray;
    var tooltip_w = self.sprite_width * 0.8;
    var tooltip_h = self.sprite_height * 0.2;
    var tooltip_x = self.x - 0.5 * tooltip_w;
    var tooltip_y = self.y - 0.5 * tooltip_h;
    draw_sprite_stretched(
        spr_reveal_tooltip, self.image_index, 
        tooltip_x, tooltip_y, tooltip_w, tooltip_h
    );
    
    var text_w = tooltip_w * 0.95;
    var text_h = tooltip_h * 0.95;
    var tooltip_text = "Reveal Card\n(-1 Vision)";
    var actual_text_w = string_width(tooltip_text);
    var actual_text_h = string_height(tooltip_text);
    var factor = min(text_w / actual_text_w, text_h / actual_text_h);  
    var sep = min(20, 20 * factor);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
      
    draw_text_ext_transformed_color(
        self.x, self.y, tooltip_text, sep, text_w, 
        factor, factor, self.image_angle, 
        c_white, c_white, c_white, c_white, 1
    );
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    window_set_cursor(cr_handpoint);
} else {
    self.image_blend = -1;
    window_set_cursor(cr_default);
}