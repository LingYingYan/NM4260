
///@desc Create or refresh the drawer and the cards in it
function make_drawer_and_cards(){

	var scale = 0.5

	drawer_width = 300;
	drawer_height = room_height;
	drawer_x = room_width;        // start hidden off-screen
	//var drawer_target = room_width = drawer_width;

	var card_width = sprite_get_width(spr_card_demo) * scale;
	var card_height = sprite_get_height(spr_card_demo) * scale;
	var card_spacing = 80;

	instance_destroy(obj_deck_drawer_card);
	instance_destroy(obj_deck_viewonly_card);
	
	player_deck = obj_player_deck_manager.denumerate();
	show_debug_message($"Player deck is {player_deck}");
	
	max_scroll = max(0, array_length(player_deck) * (card_height + card_spacing) - drawer_height);
	
	player_deck_map = ds_map_create(); 
	var scroll_index = 0; // index for scrolling

	for (var i = 0; i < array_length(player_deck); i++) {
		var card_data = player_deck[i];

		if (ds_map_exists(player_deck_map, card_data)) {
			// already exists → increment count
			var info_array = player_deck_map[? card_data];
			info_array[1] += 1;
		} else {
			// new unique card → scroll index and count
			var new_info = [scroll_index, 1];
			ds_map_add(player_deck_map, card_data, new_info);

			scroll_index += 1; // move to next slot for next unique card
		}
	}

	var keys = ds_map_keys_to_array(player_deck_map);

	for (var i = 0; i < array_length(keys); i++) {
		var card_data = keys[i];
		var info = player_deck_map[? card_data];
    
		var idx = info[0];
		var count = info[1];
		var top_margin = 50;
    
		var card_y = top_margin + card_height/2 + idx * (card_height + card_spacing);
		//var card_x = drawer_x + drawer_width / 2;
		var card_x = drawer_x + drawer_width / 2;
    
		// one instance per unique card
		if (room == rm_shop) {
			// inside shop rooms --> obj_deck_drawer_card
			var card_inst = instance_create_layer(card_x, card_y, "Instances", obj_deck_drawer_card);
			card_inst.card_data = card_data;
			card_inst.count = count;
			card_inst.idx = idx;
			card_inst.image_xscale = scale;
			card_inst.image_yscale = scale;
			card_inst.reveal = obj_player_state.data.max_vision;
			show_debug_message($"DEBUGG: card created at {card_inst.x}, {card_inst.y}");
			show_debug_message($"Now the length of map is: {ds_map_size(player_deck_map)}");
		} else {
			var card_inst_view = instance_create_layer(card_x, card_y, "Instances", obj_deck_viewonly_card);
			card_inst_view.card_data = card_data;
			card_inst_view.count = count;
			card_inst_view.idx = idx;
			card_inst_view.image_xscale = scale;
			card_inst_view.image_yscale = scale;
			card_inst_view.reveal = obj_player_state.data.max_vision;
			show_debug_message($"DEBUGG: card created at {card_inst_view.x}, {card_inst_view.y}");
		}
	}

	show_debug_message("Drawer created: " + string(id));

	// Clean up temporary array of keys
	array_delete(keys, 0, array_length(keys));
}