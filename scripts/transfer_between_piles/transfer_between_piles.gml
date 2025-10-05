function transfer_between_piles(from, to) {
    var size = from.size();
    var cards = from.clear();
    for (var i = 0; i < size; i += 1) {
        to.add(cards[i]);
    }
}