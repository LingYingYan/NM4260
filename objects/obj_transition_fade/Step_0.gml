switch (fade_direction) {
    case 1: // fade-out
        fade_alpha += fade_speed;
        if (fade_alpha >= 1) {
            fade_alpha = 1;
            room_goto(target_room);
            fade_direction = -1; // start fade-in after room change
        }
        break;

    case -1: // fade-in
        fade_alpha -= fade_speed;
        if (fade_alpha <= 0) {
            fade_alpha = 0;
            fade_direction = 0; // finished
        }
        break;
}
