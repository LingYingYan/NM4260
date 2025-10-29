event_inherited();

is_loaded = false;
loaded_map = { } 
loaded = [];
total_weight = 0;

card_effects = undefined;

read_row = function(r) {
    var card_type = self.read_cell(r, 0);
    var card_id = self.read_cell(r, 1);
    var card_name = self.read_cell(r, 2);
    var card_rarity = real(self.read_cell(r, 3));
    var card_mark_id = self.read_cell(r, 4);
    var is_obtainable = bool(self.read_cell(r, 5));
    
    var sprite = asset_get_index($"spr_{card_id}");
    var data = self.card_effects[$ card_id];
    
    var card_data = create_card_data(card_id, card_type, card_name, sprite, card_rarity, card_mark_id, data);
    self.loaded_map[$ card_id] = card_data;
    if (is_obtainable) {
        array_push(self.loaded, card_data);
        self.total_weight += card_data.get_weight();
    }
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
 * @param {Struct.CardData} card_data The card data
 * @param {String|id.layer} instance_layer The instance layer's name or ID.
 * @param {real} pos_x The x-coordinate of the card's initial position. Default to -999.
 * @param {real} pos_y The y-coordinate of the card's initial position. Default to -999.
 **/
make_card = function(card_data, instance_layer, pos_x = -999, pos_y = -999) {
    var card = instance_create_layer(pos_x, pos_y, instance_layer, obj_card);
    card.card_data = card_data;
    return card;
}
