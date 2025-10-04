
if (room_type == "start") {
	draw_set_color(c_red);
} else if (room_type == "end") {
	draw_set_color(c_green);
} else {
	draw_set_color(c_white);
}

draw_rectangle(x, y, x+48, y+48, false);