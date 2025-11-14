desc_text = scribble("Reactions between elements")
			.starting_format("font_game_text", c_black)
			.scale(2)
			.align(fa_center, fa_middle);

panel_w = 1500;
panel_h = 1000;
panel_x = (room_width - panel_w) /2;
panel_y = (room_height - panel_h) /2;

close_size = 40;
close_x1 = panel_x + panel_w - close_size - 130;
close_y1 = panel_y + 100;
close_x2 = close_x1 + close_size;
close_y2 = close_y1 + close_size;

spr_width = sprite_get_width(spr_ele_reaction_diag);

closed_btn_hovered = false;
closed_btn_color = c_black;

show_debug_message("ele reaction is created");

depth = -30000;