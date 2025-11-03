function create_tutorial_map(){
	var W = global.GRID_W;
    var H = global.GRID_H;
    var S = global.ROOM_SIZE;
	
	//fill up with all noone
	for (var row = 0; row < H; row++) {
        for (var col = 0; col < W; col++) {
			var rm = noone;
			if (row == 0 && col == 3) {
				// End room --> but set to default room type to skip card battle
				rm = new RoomData(false, false, false, false, false,"default",col, row);
			} else if (row == 1 && col == 3) {
				//shop room
				rm = new RoomData(false, false, false, false, false,"shop",col, row);	
			} else if (row == 2 && col == 3) {
				//encounter room
				rm = new RoomData(true, true, false, false, false,"encounter",col, row);
			} else if (row == 2 && col == 4) {
				// enemy rooms -- unrevealed
				rm = new RoomData(false, false, false, false, false,"enemy",col, row);
			} else if (row == 2 && col == 5) {
				// treasure room
				rm = new RoomData(false, false, false, false, false,"treasure",col, row);
			} else if (row == 3 && col == 3) {
				// enemy room -- revealed
				rm = new RoomData(true, true, false, false, false,"enemy",col, row);
			} else if (row == 4 && col == 3) {
				// start room
				rm = new RoomData(true, true, false, false, false,"start",col, row);
			}
			
            global.room_grid[row][col] = rm;
			if (rm != noone) {
				var vis = instance_create_layer(col * S + global.map_offset_x, row * S + global.map_offset_y, "Instances", DungeonRoom);
				vis.data = rm; // link the visual to the data struct
			}
		}
	}
	
	var end_room = global.room_grid[0][3];
	var shop_room = global.room_grid[1][3];
	var enc_room = global.room_grid[2][3];
	var enemy_1 = global.room_grid[2][4];
	var treasure_room = global.room_grid[2][5];
	var enemy_2 = global.room_grid[3][3];
	var start_room = global.room_grid[4][3];
	
	add_edge(end_room, shop_room);
	add_edge(shop_room, enc_room);
	add_edge(enc_room, enemy_1);
	add_edge(enemy_1, treasure_room);
	add_edge(enc_room, enemy_2);
	add_edge(enemy_2, start_room);
}