// Inherit the parent event
event_inherited();

loaded = ds_map_create();
read_row = function(r) {
    var uid = self.read_cell(r, 0);
    var display_name = self.read_cell(r, 1);
    var id_dominated = self.read_cell(r, 2);
    
    var sprite_name = $"spr_{uid}";
    var sprite = asset_get_index(sprite_name);
    var mark_data = make_mark(uid, display_name, sprite, id_dominated);
    ds_map_add(self.loaded, uid, mark_data);
    show_debug_message($"Loaded {uid}: {mark_data}");
}