draw_sprite(sprite_center, 0, room_width/2, sprite_y);

scribble_anim_wave(5, 20, 0.02);
header_text.draw(room_width/2, header_y);

desc_text.draw(room_width/2, desc_y);

// yes button
draw_sprite_stretched(sprite_btn, 0, room_width/3, buttons_y, btn_width, btn_height);
btn1_text.draw(yes_btn_x, yes_btn_y);

// no button
draw_sprite_stretched(sprite_btn, 0, room_width/3 * 2, buttons_y, btn_width, btn_height);
btn2_text.draw(no_btn_x, no_btn_y);
