draw_set_color(c_black);
draw_set_alpha(fade_alpha)
draw_sprite(spr_loading_screen, 0, room_width/2, room_height/2)
//draw_rectangle(0, 0, room_width, room_height, false);

if (!is_undefined(text_msg)) {
	var scribble_text = scribble($"{text_msg}")
		.starting_format("font_game_text", c_white)
		.scale(3)
		.align(fa_center, fa_middle);
	scribble_anim_wave(5, 20, 0.02);
	scribble_text.draw(room_width/2, room_height/2, typist);
}