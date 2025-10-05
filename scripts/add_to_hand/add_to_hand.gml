function add_to_hand(hand, card) {
    ds_list_add(hand.cards, card);
    rearrange_hand(hand, ds_list_size(hand.cards), hand.spacing, hand.cards);
}