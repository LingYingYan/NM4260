self.state_update = function() { };
if (!is_undefined(self.turn_timer) && time_source_exists(self.turn_timer)) {
    time_source_destroy(self.turn_timer);
}

self.player_win();