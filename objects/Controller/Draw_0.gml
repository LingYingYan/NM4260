// obj_controller: Draw
draw_set_color(c_ltgray);

for (var r = 0; r < global.GRID_H; r++) {
    for (var c = 0; c < global.GRID_W; c++) {
        var rm = room_grid[r][c];
        if (rm == noone) continue;

        for (var i = 0; i < array_length(rm.neighbors); i++) {
            var nb = rm.neighbors[i];
            draw_line(rm.x + 24, rm.y + 24, nb.x + 24, nb.y + 24);
        }
    }
}

// Draw connections from start/end (optional clarity)
if (instance_exists(start_room)) {
    for (var i = 0; i < array_length(start_room.neighbors); i++) {
        var nb = start_room.neighbors[i];
        draw_line(start_room.x + 24, start_room.y + 24, nb.x + 24, nb.y + 24);
    }
}
if (instance_exists(end_room)) {
    for (var i = 0; i < array_length(end_room.neighbors); i++) {
        var nb = end_room.neighbors[i];
        draw_line(end_room.x + 24, end_room.y + 24, nb.x + 24, nb.y + 24);
    }
}

draw_set_color(c_white);
