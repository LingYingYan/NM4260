//var rows = 2;
//var cards_in_row = [4, 4];
//var spacing_x = 40;
//var spacing_y = 120;
var scale = 0.8;

show_debug_message($"length of curr_shops_card: {array_length(global.curr_shop_cards)}");
for (i = 0; i < array_length(global.curr_shop_cards); i ++) {
	var card = global.curr_shop_cards[i];
	var new_card = instance_create_layer(card.pos_x, card.pos_y, "Instances", obj_shop_card);
	new_card.card_data = card.card_data;
	new_card.image_xscale = scale;
	new_card.image_yscale = scale;
	new_card.reveal = obj_player_state.data.max_vision;
}
for (j = 0; j < array_length(global.curr_shop_relics); j ++) {
	var relic = global.curr_shop_relics[j];
	show_debug_message($"DEBUG:: relic is {relic}")
	var new_relic = instance_create_layer(relic.pos_x, relic.pos_y, "Instances", obj_relic_card);
	new_relic.card_data = relic.card_data;
	new_relic.selectable = false;
	new_relic.grabbable = false;
	new_relic.image_xscale = scale;
	new_relic.image_yscale = scale;
}

var drawer = instance_create_layer(room_width - 20, room_height/2, "Instances", obj_deck_drawer);


