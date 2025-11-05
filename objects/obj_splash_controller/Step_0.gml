// fade in
if (alpha < 1) alpha = min(1, alpha + fade_in_speed);

if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_anykey)) {
    room_goto(rm_main_menu);
}
