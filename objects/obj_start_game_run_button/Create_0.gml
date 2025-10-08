// Inherit the parent event
event_inherited();

on_click = function() {
    show_debug_message("Game Started");
    var cards = obj_hand.clear();
    for (var i = 0; i < array_length(cards); i += 1) {
        obj_player_deck_manager.add(cards[i]);
    }
    
    room_goto(rm_map);
}
