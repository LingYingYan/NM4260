moused = false;
hovered = false;
picked_up = false;
scale = self.image_xscale;

goal_x = self.x;
goal_y = self.y;
normal_depth = self.depth;
current_depth = self.depth;

card_data = undefined;
dropped_area = noone;

reveal = 0;
desc = "";

ac_timestamp = 0;
anim = ac_card_flip;

set_reveal = function(value) {
    self.reveal = value;
    if (self.card_data != undefined) {
        self.desc = self.card_data.describe(self.reveal);
    }
}

state_normal = function() {
	if (obj_mouse_manager.grabbed_card != self) {
		if (!self.picked_up) {
			self.x = lerp(self.x, self.goal_x, 0.5);
			self.y = lerp(self.y, self.goal_y, 0.5);
			if (x < goal_x + 1 && x > goal_x - 1 && y < goal_y + 1 && y > goal_y - 1) {
				self.current_depth = self.normal_depth;
			}
		}

		picked_up = false;
	} else {
		picked_up = true;
		self.current_depth = -10000;
    }
}

state_flip = function() {
    self.ac_timestamp += delta_time / 1000000;
    var animation_x = animcurve_get_channel(self.anim, "xScale");
    var animation_y = animcurve_get_channel(self.anim, "yScale");
    self.image_xscale = self.scale * animcurve_channel_evaluate(animation_x, self.ac_timestamp);
    self.image_yscale = self.scale * animcurve_channel_evaluate(animation_y, self.ac_timestamp);
    if (self.ac_timestamp >= 0.5 && self.reveal < obj_player_state.data.max_vision) {
        self.normal_depth -= 10000;
        self.set_reveal(obj_player_state.data.max_vision);
    }
    
    if (self.ac_timestamp >= 1) {
        self.ac_timestamp = 0;
        self.state_update = self.state_normal;
    } 
}

state_update = self.state_normal;
