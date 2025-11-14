if (room == rm_splash || room == rm_main_menu) {
    if (!audio_is_playing(main_menu_track)) {
        audio_stop_all();
        audio_play_sound(main_menu_track, 0, true);
    }
} else if (room == rm_battle) {
    if (!audio_is_playing(combat_track)) {
        audio_stop_all();
        audio_play_sound(combat_track, 0, true);
    }
} else if (!audio_is_playing(game_ambient)) {
    audio_stop_all();
    audio_play_sound(game_ambient, 0, true);
}