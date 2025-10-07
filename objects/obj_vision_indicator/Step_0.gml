if (instance_exists(obj_player_state)) {
    self.current = obj_player_state.data.vision;    
    self.max_value = obj_player_state.data.max_vision;
}