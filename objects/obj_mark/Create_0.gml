is_updating = true;
displayed_value = self.mark_level;
self.sprite_index = asset_get_index($"spr_{self.mark_id}");

ac_timestamp = 0;

change_by = function(k) {
    var old_value = self.mark_level;
    self.mark_level += k;
    self.mark_level = max(0, self.mark_level);
    self.is_updating = self.mark_level != old_value;
}
