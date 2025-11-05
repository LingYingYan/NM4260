// Inherit the parent event
event_inherited();

on_click = function() {
    obj_battle_manager.end_battle();
	if (!global.in_tut) {
		obj_room_manager.goto_map();
	} else {
		obj_room_manager.goto_tut_map();
	}
}