draw_set_font(fnt_default);
var n = instance_number(res_loader_spreadsheet);
//for (var i = 0; i < n; i += 1) {
//    var loader = instance_find(res_loader_spreadsheet, i);
//    loader.load();
//}

res_loader_destruction_cards.load();
res_loader_restoration_cards.load();
res_loader_alteration_cards.load();
res_loader_enchantment_cards.load();

obj_room_manager.goto_deck_selection();
