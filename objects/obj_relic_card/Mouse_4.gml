if (room != Room1) {
    exit;
}

self.card_data.activate(obj_player_state.data);
obj_hand.remove(self.id);
instance_destroy(self);
obj_player_deck_manager.remove_relic(self.card_data);
window_set_cursor(cr_default);