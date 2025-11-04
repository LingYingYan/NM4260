draw_set_color(c_gray);

for (var r = 0; r < global.GRID_H; r++) {
    for (var c = 0; c < global.GRID_W; c++) {
        var rm = global.room_grid[r][c];
        if (rm == noone) continue;


        for (var i = 0; i < array_length(rm.neighbors); i++) {
            var nb = rm.neighbors[i];
            draw_line_width(rm.x + global.map_offset_x, 
							rm.y + global.map_offset_y, 
							nb.x + global.map_offset_x, 
							nb.y + global.map_offset_y, 10);
        }
    }
}