is_updating = false;
is_executing = false;

ac_timestamp = 0;

status = undefined;
owner = undefined;

initialise = function(_status) {
    self.status = _status;
    self.sprite_index = asset_get_index($"spr_{string_lower(status.name)}");
    self.image_xscale = 0.0625;
    self.image_yscale = 0.0625;
}
