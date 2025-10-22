with (obj_treasure_card) {
	if (selected && alarm_setted == false) {
		other.alarm[0] = 30;
		alarm_setted = true;
		obj_player_deck_manager.add(id);
		show_debug_message($"Added card {id} to player deck");
	}
}