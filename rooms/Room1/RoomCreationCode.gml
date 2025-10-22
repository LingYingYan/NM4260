// layer_set_visible("DeckSelectionScreen", false);

var deck = obj_player_deck_manager.denumerate();
for (var i = 0; i < array_length(deck); i += 1) {
    show_debug_message(deck[i].name);
	show_debug_message($"Length of player deck {array_length(deck)}");
}

obj_ui_health_bar.visible = true;
obj_room_manager.goto_map();