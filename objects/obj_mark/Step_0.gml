if (!self.is_updating) {
    exit;
}

if (self.ac_timestamp >= 1) {
    self.is_updating = false;
    self.ac_timestamp = 0;
    if (self.mark_level <= 0) {
        instance_destroy(self.id);
    }
}

self.ac_timestamp += delta_time / 1000000;
self.ac_timestamp = min(1, self.ac_timestamp);
if (self.ac_timestamp >= 0.1) {
    self.displayed_value = self.mark_level;
}

var channel = animcurve_get_channel(ac_icon_scaling, "scale");
var factor = animcurve_channel_evaluate(channel, self.ac_timestamp);
self.image_xscale = factor;
self.image_yscale = factor;