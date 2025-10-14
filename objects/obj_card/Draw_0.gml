if (self.hovered) {
	// Draw a stroke around the card.
	draw_sprite_ext(spr_card_stroke_with_blur, 0, self.x + 1, self.y + 2, self.image_xscale, self.image_xscale, image_angle, c_white, 0.5);
    self.current_depth -= 10000;
    window_set_cursor(cr_handpoint);
} else {
    self.current_depth = normal_depth;
    window_set_cursor(cr_default);
}

self.depth = self.current_depth;
draw_self();
if (self.card_data != undefined) {
    var x_padding = 25;
    var y_padding = 25;
    var text_x = self.x - self.sprite_width / 2 + x_padding;
    var text_y = self.y - self.sprite_height / 2 + y_padding;
    
    if (self.reveal >= obj_player_state.max_vision) {
        draw_set_halign(fa_center);
        
        draw_set_valign(fa_middle);
        
        draw_sprite(self.card_data.sprite, self.image_index, self.x, self.y - self.sprite_height / 4 + y_padding);
        
        draw_set_valign(fa_top);
        
        draw_set_font(fnt_default_large);
        
        draw_text_ext_color(
            self.x, text_y, self.card_data.name, 
            20, self.sprite_width - 2 * x_padding,
            c_black, c_black, c_black, c_black, 1
        );
        
        draw_set_font(fnt_default);
        
        draw_set_halign(fa_left);
    }
    
    text_y = self.y + y_padding;
    
    draw_text_ext_color(
        text_x, text_y, self.desc, 
        25, self.sprite_width - 2 * x_padding,
        c_black, c_black, c_black, c_black, 1
    );   
} 
