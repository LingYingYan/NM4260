draw_self();
game_summary_text = $"[b]You won![/b]\nNumber of enemies defeated: {global.number_of_completed_combat}";
game_summary = scribble(self.game_summary_text)
    .align(fa_center, fa_top);
self.game_summary.draw(self.x, self.y - 0.35 * room_height);