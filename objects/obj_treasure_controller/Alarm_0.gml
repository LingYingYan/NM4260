show_debug_message("going to main map")
if (!global.in_tut) {
	obj_room_manager.goto_map();
} else {
	obj_room_manager.goto_tut_map();
}