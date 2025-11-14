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
    //self.image_blend = c_ltgray;
    if (self.state_update == self.state_normal) {
        self.current_depth = self.normal_depth;
    }
}

self.depth = self.current_depth;
draw_self();
if (self.card_data != undefined) {
    var x_padding = 25 * self.image_xscale;
    var y_padding = 25 * self.image_yscale;
    var text_x = self.x - self.sprite_width / 2 + x_padding;
    var text_y = self.y - self.sprite_height / 2 + y_padding;
    
    if (self.reveal >= obj_player_state.max_vision) {
        scribble($"[c_white][scale,{0.046875 * self.image_xscale}][spr_{self.card_data.mark.uid}][/s][/c]")
            .align(fa_left, fa_top)
            .draw(self.x - self.sprite_width / 2 + 20 * self.image_xscale, self.y - self.sprite_height / 2 + 20 * self.image_xscale);
        
        scribble($"[b]{self.card_data.type}[/b]")
            .align(fa_left, fa_middle)
            .scale(self.image_xscale)
            .draw(self.x - self.sprite_width / 2 + (20 + 64) * self.image_xscale, self.y - self.sprite_height / 2 + (20 + 24) * self.image_xscale);
        
        var scribble_text = scribble($"[c_white][scale,0.04][spr_{self.card_data.uid}][/s][/c]\n[b]{self.card_data.name}[/b]")
            .wrap(self.sprite_width - 2 * x_padding)
            .align(fa_center, fa_bottom);
        var text_scale = min(
            self.sprite_width / scribble_text.get_width(), 
            1.15 * self.image_xscale,
            self.sprite_height / scribble_text.get_height()
        );
        
        scribble_text.scale(text_scale).draw(self.x, self.y);
    }
    
    text_y = self.y + y_padding;
    var scribble_text = scribble(self.card_data.describe(self.reveal, self.owner, self.opponent, self.hovered, {
        index: self.effect_pointer,
        scale: self.effect_scale    
    })).wrap(self.sprite_width - 2 * x_padding);
    var text_scale = min(
        self.sprite_width / scribble_text.get_width(), 
        self.image_xscale,
        self.sprite_height / scribble_text.get_height()
    );
    scribble_text.scale(text_scale).draw(text_x, text_y);
    var region = scribble_text.region_detect(text_x, text_y, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
    if (region == undefined) {
        self.tooltip_text = "";
    } else if (string_starts_with(region, "keyword-mark-")) {
        var text = string(self.card_data.mark.describe_with_context()); 
        self.tooltip_text = text;
    } else if (string_starts_with(region, "keyword-status-")) {
        var l = string_length(region) - string_length("keyword-status-")
        var name = string_copy(region, string_length("keyword-status-") + 1, l);
        self.tooltip_text = describe_status(name);
    } else {
        self.tooltip_text = "";
    }
} 
