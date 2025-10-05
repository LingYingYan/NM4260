function create_initial_deck(deck) {
    repeat(5) {
        var card = instance_create_layer(deck.x, deck.y, "Cards", obj_card);
        card.card_data = make_card_from(res_loader_cards.get(res_fireball_card));
        deck.add(card);
    }
    
    repeat(5) {
        var card = instance_create_layer(deck.x, deck.y, "Cards", obj_card);
        card.card_data = make_card_from(res_loader_cards.get(res_healing_card));
        deck.add(card);
    }
    
    deck.shuffle();
}

