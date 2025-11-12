function create_tutorial_map(){
	var W = global.GRID_W;
    var H = global.GRID_H;
    var S = global.ROOM_SIZE;
	
	var map_w = W * S;
	var map_h = H * S;
	var offset_x = (room_width - map_w) / 2;
	var offset_y = (obj_player_state.bbox_top - map_h) / 2;
	show_debug_message($"The bbox_top is at {obj_player_state.bbox_top}");
	
	global.map_offset_x = offset_x;
	global.map_offset_y = offset_y;
	
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
				var vis = instance_create_layer(col * S + offset_x, row * S + offset_y, "Instances", DungeonRoom);
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
	
	global.map_inited = true;
	global.start_room = start_room;
	global.in_tut = true;
}

function create_tutorial_player() {
	var curr_room = global.start_room;
	var px = curr_room.x;
	var py = curr_room.y;
	var player = instance_create_layer(px + global.map_offset_x, py + global.map_offset_y, "Instances", Player);
	
	player.current_room = curr_room;
	player.prev_room = curr_room;
	global.player_current_room = curr_room;
}

function reveal_room_in_tut(rm) {
	if (rm.room_type == "encounter") {
	//encounter room --> reveal exit room and treasure room
		for (var row = 0; row < array_length(global.room_grid); row++) {
			for (var col = 0; col < array_length(global.room_grid[row]); col++) {
				var grid_rm = global.room_grid[row][col];
				if (grid_rm == noone) continue;
				show_debug_message($"DEBUG ROOM TYPE: {grid_rm.room_type}");
				if (grid_rm.room_type == "default" || grid_rm.room_type == "treasure") {
					//reveal theese rooms "default room is the end room"
					grid_rm.discovered = true;
					grid_rm.revealed = true;
				} else if (grid_rm.room_type == "shop" || grid_rm.room_type == "enemy") {
					// discover all rooms
					grid_rm.discovered = true;
				}
			}
		}
	}
}

function handle_end_room() {
	// create the loading page
	var loading = instance_create_layer(room_width/2, room_height/2,"Instances", obj_loading_page);
	loading.text_msg = "Congratulations! Are you ready for the real challenge?...";
	loading.next_room = rm_game_start;
	global.is_tut = false;
	obj_player_deck_manager.clear();
	//reset_all_global();
	show_debug_message("resetting all global variables");
}

function add_predefined_cards() {
	var attack_cards = ["card_fireball", "card_rainstorm", "card_force_of_nature"];
	var defense_card = "card_ward";
	
	repeat(4) {
		obj_player_deck_manager.add(
			res_loader_cards.make_card(res_loader_cards.loaded_map[$ defense_card], "Instances"));
	}
	
	// create the attack cards
	repeat(2){
		for (i = 0; i < array_length(attack_cards); i ++) {
			var card_type = attack_cards[i];
				obj_player_deck_manager.add(
					res_loader_cards.make_card(res_loader_cards.loaded_map[$ card_type], "Instances"));
		}
	}
	
	//create the defence cards
	
}