/// @desc Get a card in the combo
/// @param {real} index The index
/// @return {Asset.GMObject} The card instance
get = function(index) {
    switch (index) {
    	case 0:
            return self.card_1;
        case 1:
            return self.card_2;
        case 2:
            return self.card_3;
    }
}