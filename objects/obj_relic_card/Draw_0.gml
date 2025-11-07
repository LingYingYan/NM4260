if (self.hovered) {
	// Draw a stroke around the card.
	// draw_sprite_ext(spr_card_stroke_with_blur, 0, self.x + 1, self.y + 2, self.image_xscale, self.image_xscale, image_angle, c_white, 0.5);
    if (self.dropped_area != noone) {
        self.current_depth = self.dropped_area.depth - 1;    
    } else {
        self.current_depth = -10000;
    }
    
    self.image_blend = -1;
} else {
    self.image_blend = c_ltgray;
    if (self.state_update == self.state_normal) {
        self.current_depth = self.normal_depth;
    }
}

self.depth = self.current_depth;
//draw_self(); 
// replace the draw_self()
draw_sprite_ext(spr_card_demo, 0, self.x, self.y + self.hover_yoffset, self.image_xscale, self.image_xscale, 0, -1, 1);
if (self.card_data != undefined) {
    var x_padding = 25 * self.image_xscale;
    var y_padding = 25 * self.image_yscale;
    var text_x = self.x - self.sprite_width / 2 + x_padding;
    var text_y = self.y - self.sprite_height / 2 + y_padding;
    
    if (self.reveal >= obj_player_state.max_vision) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        if (sprite_exists(self.card_data.sprite)) {
            draw_sprite_ext(self.card_data.sprite, self.image_index, self.x, self.y - self.sprite_height / 4 + y_padding + self.hover_yoffset, self.image_xscale, self.image_yscale, 0, -1, 1);
        }
        
        draw_set_valign(fa_top);
        draw_set_halign(fa_left);
        
        var scribble_text = scribble($"[b]{self.card_data.name}[/b]")
            .wrap(self.sprite_width - 2 * x_padding)
            .align(fa_center, fa_bottom);
        var text_scale = min(
            self.sprite_width / scribble_text.get_width(), 
            1.15 * self.image_xscale,
            self.sprite_height / scribble_text.get_height()
        );
        
        scribble_text.scale(text_scale).draw(self.x, self.y);
    }
    
    text_y = self.y + y_padding + self.hover_yoffset; 
    
    var scribble_text = scribble($"{self.card_data.desc}\n({room == rm_shop ? "Click to purchase" : "Click to activate"})")
        .wrap(self.sprite_width - 2 * x_padding);
    var text_scale = min(
        self.sprite_width / scribble_text.get_width(), 
        self.image_xscale,
        self.sprite_height / scribble_text.get_height()
    );
    scribble_text.scale(text_scale).draw(text_x, text_y);
    
    var region = scribble_text.region_detect(text_x, text_y, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
    if (region == undefined) {
        self.tooltip_text = self.card_data.to_string();
    } else if (string_starts_with(region, "keyword-mark-")) {
        var text = string(self.card_data.mark.describe_with_context()); 
        self.tooltip_text = text;
    } else if (string_starts_with(region, "keyword-status-")) {
        var l = string_length(region) - string_length("keyword-status-")
        var name = string_copy(region, string_length("keyword-status-") + 1, l);
        self.tooltip_text = describe_status(name);
    } else {
        self.tooltip_text = self.card_data.to_string();
    }
} 