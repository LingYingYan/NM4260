draw_set_color(c_gray);

for (var r = 0; r < global.GRID_H; r++) {
    for (var c = 0; c < global.GRID_W; c++) {
        var rm = global.room_grid[r][c];
        if (!instance_exists(rm)) {
            continue;
        }


        for (var i = 0; i < array_length(rm.neighbors); i++) {
            var nb = rm.neighbors[i];
            draw_line_width(rm.x + 24, rm.y + 24, nb.x + 24, nb.y + 24, 10);
        }
    }
}

// Draw connections from start/end (optional clarity)
if (instance_exists(global.start_room)) {
    for (var i = 0; i < array_length(global.start_room.neighbors); i++) {
        var nb = global.start_room.neighbors[i];
        draw_line(global.start_room.x + 48, global.start_room.y - 24, nb.x + 24, nb.y + 24);
    }
}
if (instance_exists(global.end_room)) {
    for (var i = 0; i < array_length(global.end_room.neighbors); i++) {
        var nb = global.end_room.neighbors[i];
        draw_line(global.end_room.x + 24, global.end_room.y + 48, nb.x + 24, nb.y + 24);
    }
}

draw_set_color(c_white);


//Draw all room instances manually (ensures they appear above)
with (DungeonRoom) {
    var w = 48;
    if (room_type == "start") draw_set_color(c_yellow);
    else if (room_type == "end") draw_set_color(c_red);
    else draw_set_color(c_white);
    draw_rectangle(x, y, x + w, y + w, false);
}

