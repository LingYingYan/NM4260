event_inherited();

if (hovered) {
    hover_scale = lerp(hover_scale, 1.1, 0.15); // grow smoothly
} else {
    hover_scale = lerp(hover_scale, 1.0, 0.15); // shrink smoothly
}