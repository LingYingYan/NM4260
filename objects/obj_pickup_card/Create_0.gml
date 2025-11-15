// Inherit the parent event
event_inherited();

normal_depth = -20000;
if (instance_exists(obj_backdrop) && obj_backdrop.visible) {
    normal_depth = obj_backdrop.depth - 1;
}

on_click = function() { }