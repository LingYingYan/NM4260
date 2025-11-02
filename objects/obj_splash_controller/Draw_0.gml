
draw_sprite(spr_logo, 0, room_width / 2, room_height / 3 - 50);

draw_set_color(make_color_rgb(130, 80, 40));
draw_set_font(fnt_main_header)
var header_width = string_width(title_text);
draw_text((room_width - header_width) / 2, room_height / 2, title_text)

draw_set_font(fnt_main_menu_btn)
var prompt_width = string_width(prompt_text);
draw_text((room_width - prompt_width) / 2, room_height * 0.75, prompt_text)