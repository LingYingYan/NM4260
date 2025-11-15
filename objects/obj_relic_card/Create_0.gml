// Inherit the parent event
event_inherited();

normal_depth = -20000;

selected = false;
cost = 1;//change later
sold = false;

hovered = false;
hover_scale = 1;
hover_yoffset = 0;

image_xscale = 1;
image_yscale = 1;

if (instance_exists(obj_backdrop) && obj_backdrop.visible) {
    normal_depth = obj_backdrop.depth - 1;
}
