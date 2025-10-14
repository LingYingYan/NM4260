if (!self.can_reveal || global.pause) {
    exit;
}

if (obj_player_state.data.vision < 1) {
    show_debug_message("Cannot spend vision");
    exit;
}

obj_player_state.data.vision -= 1;
self.set_reveal(obj_player_state.data.max_vision);

var n = instance_number(obj_enemy_card);
for (var i = 0; i < n; i += 1) {
    instance_find(obj_enemy_card, i).can_reveal = false;
}