/// obj_map_controller: Draw (debug connection lines)
draw_set_color(c_ltgray);
for (var f = 0; f < array_length(room_grid); f++) {
    for (var c = 0; c < array_length(room_grid[f]); c++) {
        var R = room_grid[f][c];
        if (R == noone) continue;
        for (var i = 0; i < array_length(R.neighbors); i++) {
            var N = R.neighbors[i];
            draw_line(R.x+24, R.y+24, N.x+24, N.y+24);
        }
    }
}
draw_set_color(c_white);
