var drop_area = instance_place(self.x, self.y, obj_card_drop_area);
if (drop_area != noone) {
    place_card(self, drop_area.x, drop_area.y);
    obj_hand.remove(self.id);
    self.card_data.apply(obj_player, obj_player);
    exit;
}

var hand_area = instance_place(self.x, self.y, obj_hand);
if (hand_area != noone) {
    hand_area.add(self.id);
}