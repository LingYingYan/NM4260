function generate_from_grid(){
	
	var W = global.GRID_W;
    var H = global.GRID_H;
    var S = global.ROOM_SIZE;
	
	for (var row = 0; row < H; row++) {
        for (var col = 0; col < W; col++) {
	        var rm = instance_create_layer(col * S, row * S + S, "Instances", DungeonRoom);
	        rm.grid_x = col;
	        rm.grid_y = row;
	        room_neighbors_init(rm);
	        //global.room_grid[row][col] = rm;
	        //array_push(all_rooms, rm);
        }
    }
}