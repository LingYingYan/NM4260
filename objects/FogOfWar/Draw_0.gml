/// obj_fog: Draw
with (DungeonRoom) {
    if (!discovered) {
        draw_set_alpha(1);
        draw_set_color(c_dkgrey);
        draw_rectangle(x, y, x + sprite_width, y + sprite_height, false);
    }
}
