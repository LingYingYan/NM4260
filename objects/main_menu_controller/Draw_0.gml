draw_set_color(col_panel);
draw_roundrect(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);

// Eye icon (optional)
draw_sprite(spr_logo, 0, room_width/2, panel_y);

draw_set_color(make_color_rgb(130, 80, 40))
var scribble_header = scribble($"[wave]{title}[/wave]")
		.starting_format("fnt_main_header", make_color_rgb(130, 80, 40))
		.scale(2)
		.align(fa_center, fa_middle)

scribble_anim_wave(5, 20, 0.02);		
scribble_header.draw(room_width/2, panel_y + 200)

//scribble(title)         
//    .wrap(500)
//	.draw(room_width/2 - string_width(title)/2, panel_y + 60);


// Draw buttons
draw_set_font(fnt_button);
for (var i = 0; i < array_length(buttons); i++) {
    var bx = panel_x + (panel_w - button_width) / 2;
    var by = panel_y + 300 + i * (button_height + button_spacing);

    var col = (i == hover_index) ? col_button_hover : col_button_normal;
    draw_set_color(col);
    draw_roundrect(bx, by, bx + button_width, by + button_height, false);

    draw_set_color(col_text);
    var label = buttons[i].label;
    var text_w = string_width(label);
    var text_h = string_height(label);
    draw_text(bx + (button_width - text_w)/2, by + (button_height - text_h)/2, label);
}

// Draw Help text
draw_set_font(fnt_help);
//draw_set_color(make_color_rgb(130, 80, 40));

var color = (hover_help_index == 1) ? c_white : col_button_normal;
draw_set_colour(color);
draw_text(room_width/2 - string_width(help_txt)/2, panel_y + panel_h - 100, help_txt);
