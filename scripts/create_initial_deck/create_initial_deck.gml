function create_initial_deck(deck) {
    repeat(5) {
        var card = instance_create_layer(deck.x, deck.y, "Cards", obj_card);
        card.card_data = make_attack_card("Scorch", spr_card_demo, {
            type: "Fire",
            damage: 10
        }, {
            mark: noone,
            mark_count: 0        
        });
        deck.add(card);
    }
    
    repeat(5) {
        var card = instance_create_layer(deck.x, deck.y, "Cards", obj_card);
        card.card_data = make_heal_card("Heal", spr_card_demo, {
            amount: 6
        }, {
            mark: noone,
            mark_count: 0        
        });
        deck.add(card);
    }
    
    deck.shuffle();
}

