// for normal shop cards
with (obj_shop_card) {
	if (selected) {
		var price = cost;
		show_debug_message($"Spent {price} to buy the card");
		//if (obj_player_state.data.vision >= price) obj_player_state.data.vision -= price;
		//else obj_player_state.data.vision = 0;
		//selected = false;
		//sold = true;
		//obj_player_deck_manager.add(id);
		//other.alarm[0] = 1;
		if (obj_player_state.data.vision >= price) {
			obj_player_state.data.vision -= price;
			selected = false;
			sold = true;
			obj_player_deck_manager.add(id);
			other.alarm[0] = 1;
		}
		else {
			var msg = instance_create_layer(0, 0, "Instances", obj_popup_message);
			msg.message_text = scribble("You do not have enough vision!")
					.align(fa_center, fa_middle);
			msg.function_to_run = function(){};
			//replace with customised pop-up window
			selected = false;
			sold = false;
		}
	}
	
	if (sold) {
		//remove from the global shop cards;
		var rm_name = global.curr_shop_name;
		var rm_cardlst = global.curr_shop_cards;
		for (var i = 0; i < array_length(rm_cardlst); i++) {
		    var card = rm_cardlst[i];
		    if (card.card_data.name == card_data.name && card.card_data.type == card_data.type) {
		        array_delete(global.curr_shop_cards, i, 1); //remove the temp global card list
				show_debug_message($"LENGTH of curr_shop_cards: {array_length(global.curr_shop_cards)}");
				var shop_map = ds_map_create();
				shop_map[? "cards"] = global.curr_shop_cards;
				ds_map_set(global.shop_card, rm_name, shop_map);
				
				var debug_map = global.shop_card[? rm_name];
				var card_arr = debug_map[? "cards"];
				show_debug_message($"LENGTH of the card_arr: {array_length(card_arr)}");
		        break; // stop after removing one
		    }
		}
		show_debug_message("instance destroyed");
		instance_destroy();
		
		// once player made purchases in the shop, mark it as used --> cannot return
		var curr = global.player_current_room;
		var used_coor = [curr.x, curr.y];
		if (!contain_array(global.used_shops, used_coor)) {
			array_push(global.used_shops, used_coor);
			show_debug_message($"The shop at {curr.x}, {curr.y} is marked as used")
		}
	}
}

// for relics card
with (obj_relic_card) {
	if (selected) {
		var price = cost;
		show_debug_message($"Spent {price} to buy the relic");
		if (obj_player_state.data.vision >= price) {
			obj_player_state.data.vision -= price;
			selected = false;
			sold = true;
			obj_player_deck_manager.add_relic(card_data);
			other.alarm[0] = 1;
		}
		else {
			//show_message("Your Vision is not enough.")
			var msg = instance_create_layer(0, 0, "Instances", obj_popup_message);
			msg.message_text = scribble("You do not have enough vision!")
					.align(fa_center, fa_middle);
			msg.function_to_run = function(){};
			//replace with customised pop-up window
			selected = false;
			sold = false;
		}
	}
	
	if (sold) {
		//remove from the global shop cards;
		var rm_name = global.curr_shop_name;
		var rm_reliclst = global.curr_shop_relics;
		for (var i = 0; i < array_length(rm_reliclst); i++) {
		    var relic = rm_reliclst[i];
		    if (relic.card_data.uid == card_data.uid) {
		        array_delete(global.curr_shop_relics, i, 1); //remove the temp global card list
				show_debug_message($"LENGTH of curr_shop_relics: {array_length(global.curr_shop_relics)}");
				var shop_map = ds_map_create();
				shop_map[? "relics"] = global.curr_shop_relics;
				ds_map_set(global.shop_card, rm_name, shop_map);
				
				//var debug_map = global.shop_card[? rm_name];
				//var card_arr = debug_map[? "cards"];
				//show_debug_message($"LENGTH of the card_arr: {array_length(card_arr)}");
		        break; // stop after removing one
		    }
		}
		show_debug_message("relic instance destroyed");
		instance_destroy();
		
		// once player made purchases in the shop, mark it as used --> cannot return
		var curr = global.player_current_room;
		var used_coor = [curr.x, curr.y];
		if (!contain_array(global.used_shops, used_coor)) {
			array_push(global.used_shops, used_coor);
			show_debug_message($"The shop at {curr.x}, {curr.y} is marked as used")
		}
	}
}



var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mx, my, 40, 40, 160, 90)) {
		if (!global.in_tut) {
			obj_room_manager.goto_map();
		} else {
			obj_room_manager.goto_tut_map();
		}
    }
}

//if (!instance_exists(obj_shop_card)) {
//	// if all cards are bought
//	global.shop_used = true;
//}