// Only respond if there's an avatar in play
if (global.player_moving || Player.moving) {
	show_debug_message("stopped triggered room entering")
	exit;
}

show_debug_message("the left press event is triggered")

if (!global.player_moving) {
	is_pressing = true;
	press_time = 0;
	long_press_done = false;
	show_debug_message("The player is NOT moving, so left press trigger.");
} else {
	exit;
}
