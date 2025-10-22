event_inherited();

if (selected) {
    // Smoothly interpolate position and scale
	target_x = room_width/2;
	target_y = room_height/2;
	normal_depth = -25000;
    x = lerp(x, target_x, anim_speed);
    y = lerp(y, target_y, anim_speed);
    image_xscale = lerp(image_xscale, target_scale, anim_speed);
    image_yscale = lerp(image_yscale, target_scale, anim_speed);

}

if (hovered) {
    hover_scale = lerp(hover_scale, 1.1, 0.15); // grow smoothly
} else {
    hover_scale = lerp(hover_scale, 1.0, 0.15); // shrink smoothly
}