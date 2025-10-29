data = undefined;
mark_indicators = [];
status_indicators = [];

mark_indicators_start_x = self.bbox_left + 100;
status_indicators_start_x = self.bbox_right - 100;
indicators_y = self.bbox_top;

is_ticking_status = false;
status_index = 0;
status_timer = undefined;

initialise = function() { }

add_marks = function(mark_id, multiplicity) {
    if (mark_id == "none" || multiplicity == 0) {
        return;
    }
        
    self.rearrange_marks();
    
    var idx = array_find_index(self.mark_indicators, method({key : mark_id}, function(indicator) {
        return indicator.mark_id = key;     
    }));
    
    if (idx >= 0) {
        self.mark_indicators[idx].change_by(multiplicity);
    } else if (multiplicity > 0) {
        array_push(self.mark_indicators, instance_create_depth(0, self.indicators_y, self.depth - 1, obj_mark, {
            mark_id: mark_id,
            mark_level: multiplicity    
        }));
    }
    
    self.rearrange_marks();
}

add_status = function(status, success = true) {
    if (status.level == 0) {
        return;
    }
        
    if (!success) {
        var text_displacement = self.y < room_height / 2 ? irandom_range(40, 60) : irandom_range(-60, -40);
        var spawn_y = self.y < room_height / 2 ? self.y + 150 : self.y - 150;
        instance_create_depth(self.x, spawn_y, self.depth - 10001, obj_floating_text, {
            text: $"[c_red]Resisted[/c] {get_coloured_label(status.name)}",
            move_dist: text_displacement
        });   
    } else if (status.level > 0) {
        var text_displacement = self.y < room_height / 2 ? irandom_range(40, 60) : irandom_range(-40, -60);
        var spawn_y = self.y < room_height / 2 ? self.y + 150 : self.y - 150;
        instance_create_depth(self.x, spawn_y, self.depth - 10001, obj_floating_text, {
            text: get_coloured_label(status.name),
            move_dist: text_displacement
        });  
    }
    
    // Find existing indicator
    var idx = array_find_index(self.status_indicators, method({key : status.name}, function(indicator) {
        return indicator.status.name = key;     
    }));
    
    if (idx >= 0) {
        self.status_indicators[idx].change_by(status.level);
    } else if (status.level > 0) {
        var inst = instance_create_depth(0, self.indicators_y, self.depth - 1, obj_status);
        inst.initialise(status);
        inst.owner = self.data;
        array_push(self.status_indicators, inst);
        inst.is_updating = true;
    }
    
    self.rearrange_statuses();
}

rearrange_marks = function() {
    var to_remove = [];
    for (var i = 0; i < array_length(self.mark_indicators); i += 1) {
        if (!instance_exists(self.mark_indicators[i])) {
            array_push(to_remove, self.mark_indicators[i]);
        }
    }
    
    while (array_length(to_remove) > 0) {
        var elem = array_pop(to_remove);
        var idx = array_get_index(self.mark_indicators, elem);
        array_delete(self.mark_indicators, idx, 1);
    }
    
    array_sort(self.mark_indicators, function(left, right) {
        if (left.mark_id < right.mark_id) {
            return -1;
        } else if (left.mark_id > right.mark_id) {
            return 1;
        } else {
            return 0;
        }
    });
    
    var pos_x = self.mark_indicators_start_x;
    for (var i = 0; i < array_length(self.mark_indicators); i += 1) {
        self.mark_indicators[i].x = pos_x;
        pos_x += (self.mark_indicators[i].sprite_width + 25);
    }
}

rearrange_statuses = function() {
    var to_remove = [];
    for (var i = 0; i < array_length(self.status_indicators); i += 1) {
        if (!instance_exists(self.status_indicators[i])) {
            array_push(to_remove, self.status_indicators[i]);
        }
    }
    
    while (array_length(to_remove) > 0) {
        var elem = array_pop(to_remove);
        var idx = array_get_index(self.status_indicators, elem);
        array_delete(self.status_indicators, idx, 1);
    }
    
    array_sort(self.status_indicators, function(left, right) {
        if (left.status.name < right.status.name) {
            return -1;
        } else if (left.status.name > right.status.name) {
            return 1;
        } else {
            return 0;
        }
    });
    
    var pos_x = self.status_indicators_start_x;
    for (var i = 0; i < array_length(self.status_indicators); i += 1) {
        self.status_indicators[i].x = pos_x;
        pos_x -= (self.status_indicators[i].sprite_width + 25);
    }
}

execute_next_status = function() {
    if (array_length(self.status_indicators) == 0) {
        return;
    }
    
    self.is_ticking_status = true;
    self.status_indicators[self.status_index].is_executing = true;
    self.status_indicators[self.status_index].is_updating = true;
    self.status_update = self.state_tick_status;
    if (self.status_timer != undefined) {
        time_source_destroy(self.status_timer);
    }
}

state_tick_status = function() {
    if (self.status_indicators[self.status_index].is_updating) {
        return;
    }
    
    self.status_index += 1;
    if (self.status_index >= array_length(self.status_indicators)) {
        self.status_index = 0;
        if (self.status_timer != undefined) {
            time_source_destroy(self.status_timer);
        }
        
        self.status_update = function() { };
        self.rearrange_statuses();
        self.is_ticking_status = false;
        return;
    }
    
    self.status_timer = time_source_create(time_source_game, 0.5, time_source_units_seconds, self.execute_next_status);
    time_source_start(self.status_timer);
}

status_update = function() { }
