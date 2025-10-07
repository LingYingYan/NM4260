loaded = [];
total_weight = 0;

var n = instance_number(res_card);
for (var i = 0; i < n; i += 1) {
    var data = instance_find(res_card, i);
    self.loaded[array_length(self.loaded)] = data;
    self.total_weight += data.get_weight();
}

/**
 * @desc Create a random card instance based on weighted probability.
 * @param {String|id.layer} instance_layer The instance layer's name or ID.
 * @param {real} pos_x The x-coordinate of the card's initial position. Default to -999.
 * @param {real} pos_y The y-coordinate of the card's initial position. Default to -999.
 **/
get_random_card = function(instance_layer, pos_x = -999, pos_y = -999) {
    var select = irandom_range(1, self.total_weight);
    var cumulative = 0;
    for (var i = 0; i < array_length(self.loaded); i += 1) {
        cumulative += self.loaded[i].get_weight();
        if (cumulative >= select) {
            return self.make_card(self.loaded[i], instance_layer, pos_x, pos_y);
        }
    }
    
    return self.make_card(array_last(self.loaded), instance_layer, pos_x, pos_y);
}

/**
 * @desc Create a random card instance based on weighted probability. The card can be clicked.\
 * This is mainly used to generate cards for deck selection or loot boxes.
 * @param {String|id.layer} instance_layer The instance layer's name or ID.
 * @param {real} pos_x The x-coordinate of the card's initial position. Default to -999.
 * @param {real} pos_y The y-coordinate of the card's initial position. Default to -999.
 **/
get_random_selectable_card = function(instance_layer, pos_x = -999, pos_y = -999) {
    var card = self.get_random_card(instance_layer, pos_x, pos_y);
    card.selectable = true;
    card.grabbable = false;
    return card;
}

/**
 * @desc Create a random card instance based on weighted probability. The card can be dragged and played.
 * This is mainly used to generate cards for battles.
 * @param {String|id.layer} instance_layer The instance layer's name or ID.
 * @param {real} pos_x The x-coordinate of the card's initial position. Default to -999.
 * @param {real} pos_y The y-coordinate of the card's initial position. Default to -999.
 **/
get_random_draggable_card = function(instance_layer, pos_x = -999, pos_y = -999) {
    var card = self.get_random_card(instance_layer, pos_x, pos_y);
    card.selectable = false;
    card.grabbable = true;
    return card;
}

/**
 * @desc Create a card instance using a card resource object.
 * @param {id.instance} resource_id The resource object ID. By convention it starts with "res_"
 * @param {String|id.layer} instance_layer The instance layer's name or ID.
 * @param {real} pos_x The x-coordinate of the card's initial position. Default to -999.
 * @param {real} pos_y The y-coordinate of the card's initial position. Default to -999.
 **/
make_card = function(resource_id, instance_layer, pos_x = -999, pos_y = -999) {
    var card_data = make_card_from(resource_id.object_index);
    var card = instance_create_layer(pos_x, pos_y, instance_layer, obj_card);
    card.card_data = card_data;
    return card;
}