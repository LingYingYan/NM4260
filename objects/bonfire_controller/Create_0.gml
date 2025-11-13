sprite_center = spr_bonfire_bg;
sprite_btn = spr_opt_button;

btn1_text = scribble("Yes")
			.align(fa_center, fa_middle)
			.starting_format("fnt_default_large", c_white);
btn2_text = scribble("Not Now")
			.align(fa_center, fa_middle)
			.starting_format("fnt_default_large", c_white);
header_text = scribble("[wave]Rest beside the bonfire?[/wave]")
				.starting_format("font_game_text", c_white)
				.scale(3)
				.align(fa_center, fa_middle);
desc_text = scribble("Restore your health at a cost...")
			.starting_format("font_game_text", c_white)
			.align(fa_center, fa_middle);

btn_width = sprite_get_width(sprite_btn);
btn_height = sprite_get_height(sprite_btn);
btn_spacing = 20;

sprite_y = room_height /4; 
header_y = room_height / 2;

buttons_y = room_height /4 * 3; // button row
desc_y = room_height /3 * 2; // description text

yes_btn_x1 = room_width / 3;
yes_btn_y1 = buttons_y;
yes_btn_x2 = yes_btn_x1 + btn_width;
yes_btn_y2 = yes_btn_y1 + btn_height;

yes_btn_x = room_width /3 + btn_width/2;
yes_btn_y = buttons_y + btn_height / 2;

no_btn_x1 = room_width / 3 * 2;
no_btn_y1 = buttons_y;
no_btn_x2 = no_btn_x1 + btn_width;
no_btn_y2 = no_btn_y1 + btn_height

no_btn_x = room_width /3 * 2 + btn_width/2;
no_btn_y = buttons_y + btn_height / 2;

hovered_button = -1

go_next_frame = false;

