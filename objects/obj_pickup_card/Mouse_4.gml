obj_mouse_manager.update_looking_at();
if (obj_mouse_manager.looking_at == self.id) {
    if (obj_hand.contains(self.id)) {
        obj_card_selector.put_back(self.id);
    } else {
        obj_card_selector.pick(self.id);
    }
}