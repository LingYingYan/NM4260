event_inherited();

data = new PlayerData(self.max_health, self.max_health, 3, self.max_vision);

traits = [];

initialise = function() { 
    var health_bar = instance_create_depth(self.x, self.bbox_top, self.depth - 1, obj_ui_health_bar);
    health_bar.source = data;
    health_bar.max_value = data.max_hp;
    health_bar.current = data.hp;
    var vision_indicator = instance_create_depth(health_bar.bbox_left, health_bar.bbox_top - health_bar.sprite_height, self.depth - 1, obj_vision_indicator);
    vision_indicator.max_value = data.max_vision;
    vision_indicator.current = data.vision;
    array_foreach(self.data.traits, function(trait) {
        self.add_trait(trait);
    });
}

reset = function() { 
    self.data = new PlayerData(self.max_health, self.max_health, 3, self.max_vision);
    array_foreach(self.traits, function(trait) {
        instance_destroy(trait);    
    });
}

/// @desc 
/// @param {Struct.Trait} trait description
add_trait = function(trait) {
    var trait_obj = instance_create_depth(self.bbox_left - 200, self.bbox_top, self.depth - 1, obj_trait, {
        name: trait.name,
        icon: spr_trait_default,
        desc: trait.desc
    });
    
    array_push(self.traits, trait_obj);
}

rearrange_traits = function() {
    var to_remove = [];
    for (var i = 0; i < array_length(self.traits); i += 1) {
        if (!instance_exists(self.traits[i])) {
            array_push(to_remove, self.traits[i]);
        }
    }
    
    while (array_length(to_remove) > 0) {
        var elem = array_pop(to_remove);
        var idx = array_get_index(self.traits, elem);
        array_delete(self.traits, idx, 1);
    }
    
    array_sort(self.traits, function(left, right) {
        if (left.name < right.name) {
            return -1;
        } else if (left.name > right.name) {
            return 1;
        } else {
            return 0;
        }
    });
    
    var pos_y = self.bbox_top - 100;
    for (var i = 0; i < array_length(self.traits); i += 1) {
        self.traits[i].y = pos_y;
        pos_y -= (self.traits[i].get_height() + 25);
    }
}
