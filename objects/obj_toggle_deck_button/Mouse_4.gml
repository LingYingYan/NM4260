if (! drawer_open) {
	with (obj_deck_drawer) {
		 is_open = true;
	}
	drawer_open = true;
	show_debug_message("Opening drawer");
} else {
	with (obj_deck_drawer) {
		 is_open = false;
	}
	drawer_open = false;
}