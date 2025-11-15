draw_set_font(fnt_default);
draw_set_color(c_black);
draw_set_alpha(alpha);

var text_width = string_width(message_text);
draw_sprite_stretched(spr_popup_message, 0, room_width/4, room_height/4, room_width/2, room_height/2);

message_text.wrap(room_width/2 - 100).draw(room_width/2, room_height/2 - 30);
//draw_text_ext(room_width/2, room_height/2 - 30, message_text, 30, 340);
draw_set_alpha(1);
