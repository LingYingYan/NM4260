//obj_mouse_manager.update_looking_at();
//if (obj_mouse_manager.looking_at == self.id) {
//    obj_player_deck_manager.add(self.id);
//    place_card(self, obj_card_pile.x, obj_card_pile.y);
//    show_debug_message($"Add: {self.card_data.name}");
//    var n = instance_number(obj_pickup_card);
//    var unselected = [];
//    for (var i = 0; i < n; i += 1) {
//        var c = instance_find(obj_pickup_card, i);
//        if (c.id != self.id) {    
//            array_push(unselected, c);
//        }
//    }
    
//    while (array_length(unselected) > 0) {
//        instance_destroy(array_pop(unselected));
//    }
    
//    self.on_click();
//}
if (!selected) {
    selected = true;
    target_x = room_width / 2;
    target_y = room_height / 2;
    target_scale = 2; // enlarge to 2x size
}

show_debug_message("Card is pressed")