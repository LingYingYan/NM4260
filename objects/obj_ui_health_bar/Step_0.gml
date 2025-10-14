if (obj_player_state != noone) {
    self.current = obj_player_state.data.hp;    
    self.max_value = obj_player_state.data.max_hp;
}

if (max_value > 0) {
    self.image_xscale = self.normal_scale * self.current / self.max_value;
} else {
    self.image_xscale = self.normal_scale;
}