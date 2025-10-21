event_inherited();

data = new PlayerData(self.max_health, self.max_health, 3, self.max_vision);

initialise = function() { 
    var health_bar = instance_create_depth(self.x, self.bbox_top, self.depth - 1, obj_ui_health_bar);
    health_bar.source = data;
}

reset = function() { 
    self.data = new PlayerData(self.max_health, self.max_health, 3, self.max_vision);
}
