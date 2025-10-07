// Set up player data and sync with battle data
data = new PlayerData(self.starting_hp, self.starting_hp, 0, self.max_vision);
obj_battle_player.data = self.data;

target_x = x;
target_y = y;
speed = 0;
move_speed = 6;

current_room = noone;

depth = -100;

