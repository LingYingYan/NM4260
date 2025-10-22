draw_set_font(fnt_default);
var n = instance_number(res_loader_spreadsheet);
//for (var i = 0; i < n; i += 1) {
//    var loader = instance_find(res_loader_spreadsheet, i);
//    loader.load();
//}

if (!res_loader_destruction_cards.is_loaded) {
    res_loader_destruction_cards.load();
}

if (!res_loader_restoration_cards.is_loaded) {
    res_loader_restoration_cards.load();
}

if (!res_loader_alteration_cards.is_loaded) {
    res_loader_alteration_cards.load();
}

if (!res_loader_enchantment_cards.is_loaded) {
    res_loader_enchantment_cards.load();
}

if (!res_loader_traits.is_loaded) {
    res_loader_traits.load();
}

obj_room_manager.goto_deck_selection();
