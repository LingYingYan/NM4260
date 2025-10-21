var text = "Choose a reward!";
var txt_w = string_width(text);
draw_set_font(fnt_header);
draw_set_color(c_white);
draw_text(room_width/2 - txt_w/2 ,room_height/6, text);