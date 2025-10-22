obj_mouse_manager.update_looking_at();
if (obj_mouse_manager.looking_at == self.id) {
    var playable_card = instance_create_depth(self.x, self.y, self.depth - 1, obj_player_card);
    playable_card.card_data = self.card_data;
    obj_player_deck_manager.add(playable_card.id);
    place_card(playable_card, obj_card_pile.x, obj_card_pile.y);
    show_debug_message($"Add: {self.card_data.name}");
    instance_destroy(obj_pickup_card);
    self.on_click();
}