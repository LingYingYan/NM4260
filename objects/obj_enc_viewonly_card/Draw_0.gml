// mostly same with obj_card Draw, changed hover color when can/cannot remove

//if (self.hovered) {
//	// Draw a stroke around the card.
//	with (obj_deck_drawer) {
//		if (can_remove) {
//			draw_sprite_ext(spr_card_stroke_with_blur, 0, other.x + 1, other.y + 2, other.image_xscale, other.image_xscale, image_angle, other.hover_color, 0.5);
//			other.current_depth -= 10000;
			
//		}
//	}
//	window_set_cursor(cr_handpoint);
//	//draw_sprite_ext(spr_card_stroke_with_blur, 0, self.x + 1, self.y + 2, self.image_xscale, self.image_xscale, image_angle, hover_color, 0.5);
//    //self.current_depth -= 10000;
//    //window_set_cursor(cr_handpoint);
//} else {
//    self.current_depth = normal_depth;
//    window_set_cursor(cr_default);
//}

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
        
        //draw_sprite(self.card_data.sprite, self.image_index, self.x, self.y - self.sprite_height / 4 + y_padding);
        
        draw_set_valign(fa_top);
        draw_set_halign(fa_left);
        
        scribble($"[b]{self.card_data.name}[/b]")
            .scale(1.15 * self.image_xscale)
            .wrap(self.sprite_width - 2 * x_padding)
            .align(fa_center, fa_top)
            .draw(self.x, text_y);
    }
    
    text_y = self.y + y_padding;
    var scribble_text = scribble(self.card_data.describe(self.reveal, self.owner, self.opponent, self.hovered, {
        index: self.effect_pointer,
        scale: self.effect_scale    
    })).wrap(self.sprite_width - 2 * x_padding).scale(self.image_xscale);
    scribble_text.draw(text_x, text_y);
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
	
	
	// hovered drawing
//	if (self.hovered) {
//	    var scale_up = 1.6;
//	    var gap = 60;

//	    var preview_x = self.x - (self.sprite_width * self.image_xscale / 2) - gap - (self.sprite_width * self.image_xscale * scale_up / 2);
//	    var preview_y = self.y;

//		draw_set_alpha(0.5);
//	    draw_set_color(c_gray);
//	    draw_roundrect(preview_x - self.sprite_width * self.image_xscale * scale_up / 2 - 40,
//	                   preview_y - self.sprite_height * self.image_yscale * scale_up / 2 - 60,
//	                   preview_x + self.sprite_width * self.image_xscale * scale_up / 2 + 60,
//	                   preview_y + self.sprite_height * self.image_yscale * scale_up / 2 + 80,
//	                   false);
//	    draw_set_alpha(1);
//	    draw_set_color(c_white);

//	    draw_sprite_ext(self.sprite_index, 0, preview_x, preview_y,
//	        self.image_xscale * scale_up, self.image_yscale * scale_up,
//	        self.image_angle, self.image_blend, self.image_alpha);
		
	
//	    // --- Draw text on the enlarged card ---
//	    var enlarged_x_padding = 25 * self.image_xscale * scale_up;
//	    var enlarged_y_padding = 25 * self.image_yscale * scale_up;
//	    var enlarged_text_x = preview_x - self.sprite_width * self.image_xscale * scale_up / 2 - enlarged_x_padding;
//	    var enlarged_text_y = preview_y - self.sprite_height * self.image_yscale * scale_up / 2 + enlarged_y_padding;

//	    if (self.card_data != undefined) {
//	        if (self.reveal >= obj_player_state.max_vision) {
//	            draw_set_valign(fa_top);
//	            draw_set_halign(fa_left);

//	            scribble($"[b]{self.card_data.name}[/b]")
//	                .scale(1.15 * self.image_xscale * scale_up)
//	                .wrap(self.sprite_width * scale_up - 2 * enlarged_x_padding)
//	                .align(fa_center, fa_top)
//	                .draw(preview_x, enlarged_text_y);
//	        }

//	        var enlarged_text_y2 = preview_y + enlarged_y_padding;
//	        var scribble_text2 = scribble(self.card_data.describe(self.reveal, self.owner, self.opponent, true, {
//	            index: self.effect_pointer,
//	            scale: self.effect_scale    
//	        })).wrap(self.sprite_width * scale_up - 2 * enlarged_x_padding).scale(self.image_xscale * scale_up);
//	        scribble_text2.draw(enlarged_text_x, enlarged_text_y2);
//	    }
//	} 
} 
