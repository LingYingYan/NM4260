function rearrange_hand(hand, size, spacing, cards) {
    var half_width = size % 2 == 0
        ? (size / 2 - 1) * spacing + spacing / 2
        : floor(size / 2) * spacing;
    var start_x = hand.x - half_width;
    for (var i = 0; i < size; i += 1) {
        var c = cards[| i];
        place_card(c, start_x + i * spacing, hand.y);
        c.normal_depth = hand.depth - i - 1;
        c.depth = hand.depth - i - 1;
    }
}