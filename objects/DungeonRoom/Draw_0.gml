if (is_struct(self.data)) {
	
	var spr = noone;
    switch (self.data.room_type) {
        case "enemy": spr = spr_enemyRoom; break;
        case "treasure": spr = spr_treasureRoom; break;
        case "start": spr = spr_startRoom; break;
		case "bonfire": spr = spr_bonfire; break;
		case "end" : spr = spr_endRoom; break;
		case "shop": spr = spr_shop; break;
		case "encounter": spr = spr_encounter; break;
        default: spr = spr_dungeonRoom;
    }
	draw_sprite(spr, 0, x, y)
	
	if (self.data.used && self.data.room_type != "start") {
	    draw_set_alpha(0.7);
	    draw_sprite(spr_cross_overlay, 0, x, y);
	    draw_set_alpha(1);
	}
	
	//show_debug_message($"DEBUG: the room is visited: {self.data.visited}")
	
	if (!self.data.discovered) {
        draw_set_alpha(1);
        draw_set_color(c_dkgrey);
        draw_rectangle(x, y, x + sprite_width, y + sprite_height, false);
        draw_set_alpha(1);
    }
	
}