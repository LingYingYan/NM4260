if (self.hovered) {
	// Draw a stroke around the card.
	draw_sprite_ext(spr_card_stroke_with_blur, 0, self.x + 1, self.y + 2, self.scale, self.scale, image_angle, c_white, 0.5);
}

draw_self();