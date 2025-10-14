/// @description Move the grabbed card.
if (!global.pause) {
	// We do it in this manner so we can handle card stacks, as well as the mouse cursor moving
	// quickly and causing the cursor to exit the bbox of the card and dropping the card prematurely.
	if (self.grabbed_card != noone) {
		// As long as we're actually grabbing a card.
		// Set its x and y to the mouse cursor.
		self.grabbed_card.x = lerp(self.grabbed_card.x, mouse_x, self.lerp_amount);
		self.grabbed_card.y = lerp(self.grabbed_card.y, mouse_y, self.lerp_amount);
		self.looking_at = self.grabbed_card.id;
	} else {
		// Run our looking at function.
		update_looking_at();
	}

	if (!(mouse_check_button(mb_left))) {
		/// Reset grabbed card when not holding anything.
		self.grabbed_card = noone;
	}
} else {
    update_looking_at();
}