// Inherit the parent event
event_inherited();

loaded_map = ds_map_create();
loaded = [];
total_weight = 0;
read_row = function(r) {
    var card_id = self.read_cell(r, 0);
    var card_name = self.read_cell(r, 1);
    var card_rarity = real(self.read_cell(r, 2));
    var card_mark_id = self.read_cell(r, 3);
    var card_mark_multiplicity = real(self.read_cell(r, 4));
    var is_obtainable = bool(self.read_cell(r, 5));
    var card_transform_from_id = self.read_cell(r, 6);
    
    var sprite_name = $"spr_{card_id}";
    var sprite = asset_get_index(sprite_name);
    var card_data = new AlterationCardData(
        card_id, card_name, sprite, card_rarity,
        card_mark_id, card_mark_multiplicity, card_transform_from_id
    );
    
    ds_map_add(self.loaded_map, card_id, card_data);
    if (is_obtainable) {
        self.loaded[array_length(self.loaded)] = card_data;
        self.total_weight += (5 - card_rarity);
    }
    
    show_debug_message($"Loaded {card_id}: {card_data}");
}
