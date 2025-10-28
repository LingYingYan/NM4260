global.number_of_completed_combat = 0;
draw_set_font(fnt_default);
var n = instance_number(res_loader_spreadsheet);
//for (var i = 0; i < n; i += 1) {
//    var loader = instance_find(res_loader_spreadsheet, i);
//    loader.load();
//}

if (!res_loader_cards.is_loaded) {
    res_loader_cards.load();
}

if (!res_loader_enemies.is_loaded) {
    res_loader_enemies.load();
}

if (!res_loader_relics.is_loaded) {
    res_loader_relics.load();
}

obj_room_manager.goto_deck_selection();
global.timestamp = 0;
