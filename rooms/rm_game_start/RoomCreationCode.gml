global.number_of_completed_combat = 0;
obj_player_state.reset();
obj_player_state.initialise();

if (!res_loader_cards.is_loaded) {
    res_loader_cards.load();
}

if (!res_loader_enemies.is_loaded) {
    res_loader_enemies.load();
}

if (!res_loader_relics.is_loaded) {
    res_loader_relics.load();
}

if (!res_loader_traits.is_loaded) {
    res_loader_traits.load();
}

global.timestamp = 0;
