// layer_set_visible("DeckSelectionScreen", false);

var deck = obj_player_deck_manager.denumerate();
for (var i = 0; i < array_length(deck); i += 1) {
    show_debug_message(deck[i].name);
	show_debug_message($"Length of player deck {array_length(deck)}");
}

obj_room_manager.goto_map();
obj_player_state.initialise();
var relic_cards = obj_player_deck_manager.get_all_relic_cards();
for (var i = 0; i < array_length(relic_cards); i += 1) {
    relic_cards[i].scale = 0.66;
    relic_cards[i].image_xscale = 0.66;
    relic_cards[i].image_yscale = 0.66;
    obj_hand.add(relic_cards[i].id);
}