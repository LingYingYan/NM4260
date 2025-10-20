event_inherited();

//var mx = device_mouse_x_to_gui(0);
//var my = device_mouse_y_to_gui(0);

//var scaled_w = sprite_get_width(spr_card_demo)  * image_xscale * hover_scale;
//var scaled_h = sprite_get_height(spr_card_demo) * image_yscale * hover_scale;

//var left   = x - scaled_w / 2;
//var right  = x + scaled_w / 2;
//var top    = y - scaled_h / 2;
//var bottom = y + scaled_h / 2;

//if (point_in_rectangle(mx, my, left, top, right, bottom)) {
//    hovered = true;
//} else {
//    hovered = false;
//}

if (hovered) {
    hover_scale = lerp(hover_scale, 1.1, 0.15); // grow smoothly
} else {
    hover_scale = lerp(hover_scale, 1.0, 0.15); // shrink smoothly
}
