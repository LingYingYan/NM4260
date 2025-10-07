layer_set_visible("DeckSelectionScreen", false);

var deck = obj_player_deck_manager.denumerate();
for (var i = 0; i < array_length(deck); i += 1) {
    show_debug_message(deck[i].name);
}