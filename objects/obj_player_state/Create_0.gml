event_inherited();

data = new PlayerData(self.max_health, self.max_health, 3, self.max_vision);

traits = [];
relics = [];

die = function() {
    instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_death_panel);
}

initialise = function() { 
    self.status_indicators = [];
    self.mark_indicators = [];
    var hand = instance_find(obj_hand, 0);
    var d = instance_exists(hand) ? hand.depth - 100 : self.depth - 1;
    var health_bar = instance_create_depth(self.x, self.bbox_top, d, obj_ui_health_bar);
    health_bar.source = data;
    health_bar.max_value = data.max_hp;
    health_bar.current = data.hp;
    var vision_indicator = instance_create_depth(health_bar.bbox_left, health_bar.bbox_top - health_bar.sprite_height, d, obj_vision_indicator);
    vision_indicator.max_value = data.max_vision;
    vision_indicator.current = data.vision;
    array_foreach(self.data.traits, function(trait) {
        self.add_trait(trait);
    });
}

reset = function() { 
    obj_player_deck_manager.clear();
    self.data = new PlayerData(self.max_health, self.max_health, 3, self.max_vision);
    array_foreach(self.traits, function(trait) {
        instance_destroy(trait);    
    });
    
    for (var i = 0; i < array_length(self.relics); i += 1) {
        self.relics[i].data.revoke(self.data);
        instance_destroy(self.relics[i]);
    }
    
    self.relics = [];
    
    show_debug_message("Loading traits");
    if (!struct_exists(global, "persistent_traits")) {
        global.persistent_traits = [];
    }
    
    obj_traits_manager.remaining_traits = [];
    initialise_traits();
    obj_traits_manager.owned_traits = [];
    
    for (var i = 0; i < array_length(global.persistent_traits); i += 1) {
        show_debug_message($"{global.persistent_traits[i].name}");
        obj_player_state.add_trait(global.persistent_traits[i]);
        gain_trait(self.data, global.persistent_traits[i]);
        var idx = array_get_index(obj_traits_manager.remaining_traits, global.persistent_traits[i]);
        array_delete(obj_traits_manager.remaining_traits, idx, 1);
        array_push(obj_traits_manager.owned_traits, global.persistent_traits[i]);
    }
}

/// @desc 
/// @param {Struct.Trait} trait description
add_trait = function(trait) {
    var trait_obj = instance_create_depth(self.bbox_left - 200, self.bbox_top, self.depth - 1, obj_trait, {
        name: trait.name,
        icon: asset_get_index($"spr_trait_{trait.uid}"),
        desc: trait.desc
    });
    
    array_push(self.traits, trait_obj);
}

rearrange_traits_and_relics = function() {
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
    
    to_remove = [];
    for (var i = 0; i < array_length(self.relics); i += 1) {
        if (global.number_of_completed_combat >= self.relics[i].expire) {
            array_push(to_remove, self.relics[i]);
        }
    }
    
    while (array_length(to_remove) > 0) {
        var elem = array_pop(to_remove);
        var idx = array_get_index(self.relics, elem);
        array_delete(self.relics, idx, 1);
        elem.data.revoke(self.data);
        instance_destroy(elem);
    }
    
    array_sort(self.relics, function(left, right) {
        if (left.name < right.name) {
            return -1;
        } else if (left.name > right.name) {
            return 1;
        } else {
            return 0;
        }
    });
    
    var pos_y = self.bbox_top - 100;
    for (var i = 0; i < array_length(self.relics); i += 1) {
        self.relics[i].y = pos_y;
        pos_y -= (self.relics[i].get_height() + 25);
    }
    
    pos_y -= 25;
    for (var i = 0; i < array_length(self.traits); i += 1) {
        self.traits[i].y = pos_y;
        pos_y -= (self.traits[i].get_height() + 25);
    }
}

use_relic = function(relic) {
    if (relic.duration <= 0) {
        return;
    }
    
    var relic_obj = instance_create_depth(self.bbox_left - 200, self.bbox_top, self.depth - 1, obj_relic, {
        icon: relic.sprite,
        name: relic.name,
        desc: relic.to_string(),
        expire: relic.duration + global.number_of_completed_combat
    });
    
    relic_obj.data = relic;
    array_push(self.relics, relic_obj);
}
