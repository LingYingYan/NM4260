var n = instance_number(res_loader_spreadsheet);
for (var i = 0; i < n; i += 1) {
    instance_find(res_loader_spreadsheet, i).load();    
}

layer_set_visible("DeckSelectionScreen", true);
