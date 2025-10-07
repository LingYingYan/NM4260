var deck = obj_player_deck_manager.denumerate();
for (var i = 0; i < array_length(deck); i += 1) {
    var card = instance_create_layer(obj_card_pile.x, obj_card_pile.y, "Cards", obj_card);
    card.card_data = deck[i];
    obj_card_pile.add(card);
}

obj_battle_manager.start_battle();