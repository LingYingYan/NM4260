//// background
//draw_set_color(make_color_rgb(25, 25, 25));
//draw_rectangle(drawer_x, 0, drawer_x + drawer_width, drawer_height, false);

//var prev = gpu_get_scissor();
//var scissor_y = display_get_height() - drawer_height;
//gpu_set_scissor(drawer_x, scissor_y, drawer_width, drawer_height);


//gpu_set_scissor(prev);
//draw_text(room_width - drawer_width, room_height/2, "Press 'I' to open your deck.");

if (drawer_x < room_width) { // only clip when drawer visible
    var prev = gpu_get_scissor();
    var scissor_y = display_get_height() - drawer_height;
    gpu_set_scissor(drawer_x, 0, drawer_width, drawer_height);

    draw_set_color(c_black);
	draw_set_alpha(0.7);
	draw_rectangle(drawer_x, 0, drawer_x + drawer_width, drawer_height, false);
	draw_set_alpha(1);
	with (obj_deck_drawer_card) {
		if (count > 1) {
			draw_set_color(c_white)
			draw_text(x + other.card_width/2 + 10, y, "x" + string(count));
		}
		draw_text(x - other.card_width/2 - 5, y + other.card_height/2 + 10, "-0.5 Vision to remove");
	}

	gpu_set_scissor(prev);
    //else gpu_set_sc(false);
}