hand = obj_hand;
alarm_setted = false;
//var card1 = instance_create_layer(view_wport[0]/2 - 128, view_hport[0]/2-100, "Instances", obj_card);
//var card2 = instance_create_layer(view_wport[0]/2 + 128, view_hport[0]/2-100, "Instances", obj_card);
//show_debug_message("treasure card is created")

//screen_w = display_get_gui_width();
//screen_h = display_get_gui_height();

var card_w = sprite_get_width(spr_card_demo);
var card_h = sprite_get_height(spr_card_demo);
var spacing = 50;

var total_width = (3 * card_w) + (2 * spacing);
var start_x = (room_width - total_width) / 2 + card_w/2;

var pos_y = room_height/2;

var selected_cards = [];

for (var i = 0; i < 3; i++) {
    var pos_x = start_x + i * (card_w + spacing);

    var unique_card = noone;
    var duplicate = true;

    while (duplicate) {
        duplicate = false;

        var card = res_loader_cards.get_random_card("Instances");

        for (var j = 0; j < array_length(selected_cards); j++) {
            if (card.card_data.type == selected_cards[j].card_data.type && 
			card.card_data.name == selected_cards[j].card_data.name) {
                duplicate = true;
                break;
            }
        }
		// new card
        if (!duplicate) {
            unique_card = card;
            array_push(selected_cards, card);
        }
    }

    // create instance with unique card data
    var new_card = instance_create_layer(pos_x, pos_y, "Instances", obj_treasure_card);
    new_card.card_data = unique_card.card_data;
    new_card.set_reveal(obj_player_state.data.max_vision);

    show_debug_message($"Created unique card: {new_card.card_data.name}");
}

