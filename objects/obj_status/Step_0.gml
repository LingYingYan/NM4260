self.displayed_value = self.status == undefined || self.status == noone ? 0 : self.status.level;
if (!self.is_updating) {
    exit;
}

if (self.ac_timestamp >= 1) {
    self.is_updating = false;
    self.ac_timestamp = 0;
}

if (self.ac_timestamp >= 0.1) {
    if (self.is_executing) {
        self.is_executing = false;
        self.status.execute(self.owner);
        self.status.decay(self.owner);
    }
    
    if (self.status.level <= 0) {
        self.status.terminate(self.owner);
    }
}

self.ac_timestamp += delta_time / 1000000;
self.ac_timestamp = min(1, self.ac_timestamp);

var channel = animcurve_get_channel(ac_icon_scaling, "scale");
var factor = animcurve_channel_evaluate(channel, self.ac_timestamp);
self.image_xscale = 0.0625 * factor;
self.image_yscale = 0.0625 * factor;