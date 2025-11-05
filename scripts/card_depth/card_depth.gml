function set_card_depth(card, d) {
    card.normal_depth = d;
    card.current_depth = d;
    card.depth = d;
    show_debug_message($"Set card depth: {card.normal_depth} = {d}");
}