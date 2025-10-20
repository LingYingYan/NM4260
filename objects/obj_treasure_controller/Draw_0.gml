var text = "Choose a reward!";
var txt_w = string_width(text);
draw_set_font(fnt_header);
draw_set_color(c_white);
draw_text(surface_get_width(application_surface)/2 - txt_w * 2 ,surface_get_height(application_surface)/5, text);