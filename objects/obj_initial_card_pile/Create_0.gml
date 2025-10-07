// Inherit the parent event
event_inherited();

if (!instance_exists(self.card)) {
    instance_create_layer(0, 0, "Instances", self.card);
}

repeat (self.count) {
    var card_data = make_card_from(self.card);
    var card = instance_create_layer(self.x, self.y, "Instances", obj_card);
    card.card_data = card_data;
    card.grabbable = false;
    card.selectable = true;
    self.add(card.id);
}