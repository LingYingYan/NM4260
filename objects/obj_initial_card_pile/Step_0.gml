if (!res_loader_cards.is_loaded || self.is_initialised) {
    exit;
}

self.is_initialised = true;
var card_data = res_loader_cards.loaded_map[$ self.card];
repeat (self.count) {
    var card = instance_create_layer(self.x, self.y, "Instances", obj_player_card);
    card.card_data = card_data;
    card.grabbable = false;
    card.selectable = false;
    card.reveal = obj_player_state.data.max_vision
    card.owner = obj_player_state.data;
    self.add(card.id);
}