if (is_callable(option_effect)) {
	show_debug_message($"Choosing option: {option_name}");
	option_effect();
	show_message(option_message);
	obj_room_manager.goto_map();
}