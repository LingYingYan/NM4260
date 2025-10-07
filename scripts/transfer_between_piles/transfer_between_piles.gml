function transfer_between_piles(from, to, reveal, is_grabbale) {
    var size = from.size();
    var cards = from.clear();
    for (var i = 0; i < size; i += 1) {
        cards[i].reveal = 0;
        cards[i].grabbable = is_grabbale;
        cards[i].selectable = false;
        to.add(cards[i]);
    }
}