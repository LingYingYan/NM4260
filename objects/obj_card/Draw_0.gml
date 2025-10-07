if (self.hovered) {
	// Draw a stroke around the card.
	draw_sprite_ext(spr_card_stroke_with_blur, 0, self.x + 1, self.y + 2, self.scale, self.scale, image_angle, c_white, 0.5);
    self.current_depth -= 10000;
} else {
    self.current_depth = normal_depth;
}

self.depth = self.current_depth;

if (self.card_data != undefined) {
    self.sprite_index = self.card_data.sprite;    
}

draw_self();
var text_x = self.x - self.sprite_width / 2 + 25;
var text_y = self.y - self.sprite_height / 2 + 25;
draw_text_color(text_x, text_y, self.card_data.describe(), c_black, c_black, c_black, c_black, 255);