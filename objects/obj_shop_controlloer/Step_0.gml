with (obj_shop_card) {
	if (selected) {
		var price = cost;
		show_debug_message($"Spent {price} to buy the card");
		obj_player_state.data.vision -= price;
		selected = false;
		sold = true;
		obj_player_deck_manager.add(id);
		other.alarm[0] = 1;
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
				//(global.shop_card[? rm_name])[? "cards"] = global.curr_shop_cards;
				//global.shop_card.rm_name.cards = global.curr_shop_cards; //replace the global map with new cards
				
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
		array_push(global.used_shops, used_coor);
		show_debug_message($"The shop at {curr.x}, {curr.y} is marked as used")
	}
}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mx, my, 40, 40, 160, 90)) {
		
        obj_room_manager.goto_map();
    }
}

//if (!instance_exists(obj_shop_card)) {
//	// if all cards are bought
//	global.shop_used = true;
//}