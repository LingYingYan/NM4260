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
    var x_padding = 25 * self.image_xscale;
    var y_padding = 25 * self.image_yscale;
    var text_x = self.x - self.sprite_width / 2 + x_padding;
    var text_y = self.y - self.sprite_height / 2 + y_padding;
    
    if (self.reveal >= obj_player_state.max_vision) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        draw_sprite(self.card_data.sprite, self.image_index, self.x, self.y - self.sprite_height / 4 + y_padding);
        
        draw_set_valign(fa_top);
        draw_set_halign(fa_left);
        
        scribble($"[b]{self.card_data.name}[/b]")
            .scale(1.15 * self.image_xscale)
            .wrap(self.sprite_width - 2 * x_padding)
            .align(fa_center, fa_top)
            .draw(self.x, text_y);
    }
    
    text_y = self.y + y_padding;
    var scribble_text = scribble(self.desc).wrap(self.sprite_width - 2 * x_padding).scale(self.image_xscale);
    scribble_text.draw(text_x, text_y);
    var region = scribble_text.region_detect(text_x, text_y, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
    if (region != undefined && string_starts_with(region, "keyword-mark-")) {
        var text = string(self.card_data.mark.describe_with_context(self.card_data.is_offensive)); 
        self.tooltip_text = text;
    } else {
        self.tooltip_text = "";
    }
    
    if (self.hovered && self.reveal >= 1) {
        obj_tooltip.tooltip_text = self.tooltip_text;
    } 
} 
