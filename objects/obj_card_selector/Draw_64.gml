if (room == rm_game_start) {
    draw_set_halign(fa_center);
    draw_set_font(fnt_default_large);
    
    var gui_x = display_get_gui_width() * 0.85;
    var gui_y = display_get_gui_height() * 0.6;
    draw_text_color(
        gui_x, gui_y, $"Pick {10 - obj_hand.size()} more cards to start", 
        c_black, c_black, c_black, c_black, 1
    );
    
    draw_set_font(fnt_default);
    draw_set_halign(fa_left);
}