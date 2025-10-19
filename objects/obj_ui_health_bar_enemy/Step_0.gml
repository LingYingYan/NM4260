if (obj_enemy != noone) {
    self.current = obj_enemy.data.hp;    
    self.max_value = obj_enemy.data.max_hp;
}

if (max_value > 0) {
    self.image_xscale = self.normal_scale * self.current / self.max_value;
} else {
    self.image_xscale = self.normal_scale;
}