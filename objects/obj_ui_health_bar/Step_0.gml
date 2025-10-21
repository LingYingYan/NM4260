if (self.source != undefined) {
    self.current = self.source.hp;    
    self.max_value = self.source.max_hp;
}

if (max_value > 0) {
    self.image_xscale = self.normal_scale * self.current / self.max_value;
} else {
    self.image_xscale = self.normal_scale;
}