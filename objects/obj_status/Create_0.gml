is_updating = true;
displayed_value = self.status_level;
self.sprite_index = asset_get_index($"spr_{string_lower(self.status_type)}");

ac_timestamp = 0;

change_by = function(k) {
    var old_value = self.status_level;
    self.status_level += k;
    self.status_level = max(0, self.status_level);
    self.is_updating = self.status_level != old_value;
}