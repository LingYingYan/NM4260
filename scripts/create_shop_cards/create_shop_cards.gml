/// @description Generate a list of unique shop cards with position data
/// @return Array of card

function create_shop_cards(rows, cards_in_row, spacing_x, spacing_y, scale)
{
    var surf_w = room_width;
    var surf_h = room_height;

    var card_w = sprite_get_width(spr_card_demo) * scale;
    var card_h = sprite_get_height(spr_card_demo) * scale;

    var total_height = (card_h * rows) + spacing_y;
    var start_y = (surf_h - total_height) / 2 + card_h / 2;

    var result_cards = [];

    for (var row = 0; row < rows; row++) {
        var num_cards = cards_in_row[row];

        // Total width for this row
        var total_w = num_cards * card_w + (num_cards - 1) * spacing_x;
        var start_x = (surf_w - total_w) / 2 + card_w / 2;
        var pos_y = start_y + row * (card_h + spacing_y);

        for (var i = 0; i < num_cards; i++) {
            var pos_x = start_x + i * (card_w + spacing_x);

            // Ensure uniqueness
            var unique_card = noone;
            var duplicate = true;
            while (duplicate) {
                duplicate = false;
                var card = res_loader_cards.get_random_card("Instances");

                for (var j = 0; j < array_length(result_cards); j++) {
                    if (card.card_data.type == result_cards[j].card_data.type &&
                        card.card_data.name == result_cards[j].card_data.name) {
                        duplicate = true;
                        break;
                    }
                }

                if (!duplicate) {
                    unique_card = card;
                    array_push(result_cards, {
                        x: pos_x,
                        y: pos_y,
                        card_data: unique_card.card_data
                    });
                }
            }
        }
    }

    return result_cards;
}


function handle_shop_cards(rm) {
	var rows = 2;
	var cards_in_row = [4, 4];
	var spacing_x = 40;
	var spacing_y = 120;
	var scale = 0.6;
	var rm_name = string(rm.room_name);

	// Ensure global.shop_card exists
	if (!ds_exists(global.shop_card, ds_type_map)) {
		global.shop_card = ds_map_create();
	}

	// Determine if shop needs new cards
	if (!ds_map_exists(global.shop_card, rm_name)) {
		var card_lst = create_shop_cards(rows, cards_in_row, spacing_x, spacing_y, scale);
		
		var shop_map = ds_map_create();
		shop_map[? "cards"] = card_lst;
		shop_map[? "refresh"] = false;

		ds_map_set(global.shop_card, rm_name, shop_map);
		show_debug_message("TYPE"+ string(ds_exists(global.shop_card, ds_type_map))); // should be true
		var inner = global.shop_card[? rm_name];
		show_debug_message(ds_exists(inner, ds_type_map));

	} else {
		
		//var old_shop = global.shop_card[? rm_name];
		//if (ds_exists(old_shop, ds_type_map)) {
		//	if (ds_exists(old_shop[? "cards"], ds_type_list))
		//		ds_list_destroy(old_shop[? "cards"]);
		//	ds_map_destroy(old_shop);
		//}
		var shop_map = global.shop_card[? rm_name];
		 if (shop_map[? "refresh"] == true) {
			var card_lst = create_shop_cards(rows, cards_in_row, spacing_x, spacing_y, scale);
			var new_shop_map = ds_map_create();
			new_shop_map[? "cards"] = card_lst;
			new_shop_map[? "refresh"] = false;
			ds_map_set(global.shop_card, rm_name, new_shop_map);
		 }
	}
	// Update current active shop reference
	updated_shop_map = global.shop_card[? rm_name];
	global.curr_shop_cards = updated_shop_map[? "cards"];
	global.curr_shop_name  = rm.room_name;
}

function empty_shop_card() {
	if (ds_exists(global.shop_card, ds_type_map)) {
	    var keys = ds_map_keys_to_array(global.shop_card);

	    for (var i = 0; i < array_length(keys); i++) {
	        var key = keys[i];
	        var shop_map = global.shop_card[? key];

	        if (ds_exists(shop_map, ds_type_map)) {
	            // destroy the cards list inside
				var cards = shop_map[? "cards"];
			    if (is_array(cards)) {
			        // Just clear array reference — arrays auto-free in GML
			        shop_map[? "cards"] = [];
			    } else if (ds_exists(cards, ds_type_list)) {
			        // Proper DS list cleanup
			        ds_list_destroy(cards);
			    }
	   
	            // destroy the shop map itself
	            ds_map_destroy(shop_map);
	        }
	    }

	    // destroy the global shop_card map
	    ds_map_destroy(global.shop_card);
	}

	global.shop_card = ds_map_create();
	global.curr_shop_cards = ds_list_create();

}