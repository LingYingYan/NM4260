//// background
//draw_set_color(make_color_rgb(25, 25, 25));
//draw_rectangle(drawer_x, 0, drawer_x + drawer_width, drawer_height, false);

//var prev = gpu_get_scissor();
//var scissor_y = display_get_height() - drawer_height;
//gpu_set_scissor(drawer_x, scissor_y, drawer_width, drawer_height);


//gpu_set_scissor(prev);

if (drawer_x < room_width) { // only clip when drawer visible
    var prev = gpu_get_scissor();
    var scissor_y = display_get_height() - drawer_height;
    gpu_set_scissor(drawer_x, scissor_y, drawer_width, drawer_height);

    draw_set_color(c_aqua);
	draw_rectangle(drawer_x, 0, drawer_x + drawer_width, drawer_height, false);
	with (obj_deck_drawer_card) {
		if (count > 1) {
			draw_text(x + other.card_width + 10, y, "x" + string(count));
			show_debug_message("Count of the card is drawn");
		}
	}

	gpu_set_scissor(prev);
    //else gpu_set_sc(false);
}