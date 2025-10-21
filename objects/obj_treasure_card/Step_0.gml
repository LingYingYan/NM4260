event_inherited();

if (selected) {
    // Smoothly interpolate position and scale
	normal_depth = -25000;
    x = lerp(x, target_x, anim_speed);
    y = lerp(y, target_y, anim_speed);
    image_xscale = lerp(image_xscale, target_scale, anim_speed);
    image_yscale = lerp(image_yscale, target_scale, anim_speed);

    // Once the card is nearly centered and enlarged → trigger transition
    if (!alarm_setted && point_distance(x, y, target_x, target_y) < 5 && abs(image_xscale - target_scale) < 0.05) {
        alarm[0] = 20;
		alarm_setted = true;
		// add the card to the player deck
		obj_player_deck_manager.add(self.id);
		show_debug_message($"Added card {self.id} to player deck");
    }
}

if (hovered) {
    hover_scale = lerp(hover_scale, 1.1, 0.15); // grow smoothly
} else {
    hover_scale = lerp(hover_scale, 1.0, 0.15); // shrink smoothly
}