is_updating = false;
is_executing = false;

ac_timestamp = 0;

status = undefined;
owner = undefined;

initialise = function(_status) {
    self.status = _status;
    self.sprite_index = asset_get_index($"spr_{string_lower(status.name)}");
}

change_by = function(k) {
    var old_value = self.status.level;
    self.status.level += k;
    self.status.level = max(0, self.status.level);
    self.is_updating = self.status.level != old_value;
}