if (room == rm_shop) {
	// inside shop
	if (!selected && !sold) {
		selected = true;
		
	}
	show_debug_message("Relics marked selected")
} 

if (room != Room1 && room != rm_tutorial) {
    exit;
}

self.card_data.activate(obj_player_state.data);
obj_hand.remove(self.id);
instance_destroy(self);
obj_player_deck_manager.remove_relic(self.card_data);
obj_player_state.use_relic(self.card_data);
window_set_cursor(cr_default);