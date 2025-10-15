if (is_struct(self.data)) {
    switch (self.data.room_type) {
        case "enemy": draw_sprite(spr_enemyRoom, 0, x, y); break;
        case "treasure": draw_sprite(spr_treasureRoom, 0, x, y); break;
        case "start": draw_sprite(spr_startRoom, 0, x, y); break;
		case "bonfire": draw_sprite(spr_bonfire, 0, x, y); break;
		case "end" : draw_sprite(spr_endRoom, 0, x, y); break;
        default: draw_sprite(spr_dungeonRoom, 0, x, y);
    }
	
	if (!self.data.discovered) {
        draw_set_alpha(0.5);
        draw_set_color(c_dkgrey);
        draw_rectangle(x, y, x + sprite_width, y + sprite_height, false);
        draw_set_alpha(1);
    }
}