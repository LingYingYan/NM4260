// Inherit the parent event
event_inherited();

on_click = function() {
    show_debug_message("Game Started");
    var cards = obj_hand.clear();
    for (var i = 0; i < array_length(cards); i += 1) {
        obj_player_deck_manager.add(cards[i]);
    }
    
    var deck = obj_player_deck_manager.denumerate();
    for (var i = 0; i < array_length(deck); i += 1) {
        show_debug_message(deck[i].name);
    }
}
