//// background
//draw_set_color(make_color_rgb(25, 25, 25));
//draw_rectangle(drawer_x, 0, drawer_x + drawer_width, drawer_height, false);

//var prev = gpu_get_scissor();
//var scissor_y = display_get_height() - drawer_height;
//gpu_set_scissor(drawer_x, scissor_y, drawer_width, drawer_height);


if (drawer_x < room_width) { // only clip when drawer visible
    var prev = gpu_get_scissor();
    var scissor_y = room_height - drawer_height;
    gpu_set_scissor(drawer_x, 0, drawer_width, drawer_height);

    draw_set_color(#735129);
	draw_set_alpha(0.7);
	//draw_sprite_stretched(spr_drawer, 0, drawer_x, 0, drawer_width, drawer_height);
	draw_rectangle(drawer_x, 0, drawer_x + drawer_width, drawer_height, false);
	draw_set_alpha(1);
	if (room == rm_shop) {
		with (obj_deck_drawer_card) {
			if (count > 1) {
				draw_set_color(c_white)
				draw_text(x + other.card_width/2 + 20, y, "x" + string(count));
			}
			if (other.can_remove) {
				draw_set_color(c_aqua);
				scribble("-0.5 Vision to remove")
					.starting_format("font_game_text", c_white)
					.align(fa_center, fa_middle)
					.draw(x, y + other.card_height/2 + 20);
				//draw_text(x - other.card_width/2, y + other.card_height/2 + 10, "-0.5 Vision to remove");
			}
		}
	} else {
		with (obj_deck_viewonly_card) {
			if (count > 1) {
				draw_set_color(c_white)
				draw_text(x + other.card_width/2 + 20, y, "x" + string(count));
			}
		}
	}

	gpu_set_scissor(prev);
    //else gpu_set_sc(false);
}