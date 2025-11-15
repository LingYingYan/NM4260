draw_set_color(c_navy);
//draw_sprite(spr_encounter_option_button, 0, x, y);
draw_sprite_stretched(spr_opt_button, 0, x - button_w/2, y - button_h / 2, button_w, button_h)
scribble($"{option_name}")
		.align(fa_center, fa_middle)
		.draw(x, y);