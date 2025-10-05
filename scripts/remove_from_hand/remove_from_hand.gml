function remove_from_hand(hand, card) {
    var index = ds_list_find_index(hand.cards, card);
    if (index != -1) {
        ds_list_delete(hand.cards, index);
    }
    
    rearrange_hand(hand, ds_list_size(hand.cards), hand.spacing, hand.cards);
}