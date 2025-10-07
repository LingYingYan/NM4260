var n = instance_number(res_loader_spreadsheet);
for (var i = 0; i < n; i += 1) {
    var loader = instance_find(res_loader_spreadsheet, i);
    loader.load();
}

obj_room_manager.goto_deck_selection();
