var drop_area = instance_place(self.x, self.y, obj_card_drop_area);
if (drop_area != noone) {
    place_card(self, drop_area.x, drop_area.y);
    obj_hand.remove(self.id);
    // self.card_data.apply(obj_player, obj_player);
    drop_area.card = self;
    self.dropped_area = drop_area;
    return;
}

var hand_area = instance_place(self.x, self.y, obj_hand);
if (hand_area != noone) {
    hand_area.add(self.id);
    if (self.dropped_area == noone || self.dropped_area == undefined) {
        return;  
    }
    
    self.dropped_area.card = noone;
    self.dropped_area = noone;
}