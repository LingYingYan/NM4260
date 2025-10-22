remaining_traits = [];
owned_traits = [];

total_weight = 0;

get_random = function() {
    var select = irandom_range(1, self.total_weight);
    var cumulative = 0;
    for (var i = 0; i < array_length(self.remaining_traits); i += 1) {
        cumulative += self.remaining_traits[i].get_weight();
        if (cumulative >= select) {
            array_push(self.owned_traits, self.remaining_traits[i]);
            array_delete(self.remaining_traits, i, 1);
            return array_last(self.owned_traits);
        }
    }
    
    return undefined;
}