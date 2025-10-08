function reset_map(min_rooms_required) {
    show_debug_message("reset_map() called");
    with (DungeonRoom) instance_destroy();

    // true = spawn at bonfire
    var rooms = initialize_map(min_rooms_required, true);
	if (instance_exists(Player) && instance_exists(global.bonfire_room)) {
        var pl = instance_find(Player, 0);
        pl.x = global.bonfire_room.x;
        pl.y = global.bonfire_room.y;
        pl.current_room = global.bonfire_room;
        show_debug_message("Player repositioned to new bonfire at: " 
            + string(pl.x) + "," + string(pl.y));
    }
	return rooms;
}
