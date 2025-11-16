draw_self();
game_summary_text = $"[b]You won![/b]";
game_summary = scribble(self.game_summary_text)
	.scale(3)
    .align(fa_center, fa_top);
game_enemy_count_text = $"Number of enemies defeated: {global.number_of_completed_combat}";
game_enemy_count = scribble(self.game_enemy_count_text)
	.align(fa_center, fa_middle);
self.game_summary.draw(self.x, self.y - 0.35 * room_height);
self.game_enemy_count.draw(self.x, self.y - 0.15 * room_height)