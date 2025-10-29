function trigger_room_transition(_target_room, _color){
    if (!instance_exists(obj_transition_fade))
        instance_create_layer(0, 0, "Instances", obj_transition_fade);

    with (obj_transition_fade) {
        target_room = _target_room;
        fade_direction = 1; // fade-out
		fade_color = _color;
    }
}