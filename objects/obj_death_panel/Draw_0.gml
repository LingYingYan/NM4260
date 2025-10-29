draw_self();
game_summary_text = $"[b]You died.[/b]\nNumber of enemies defeated: {global.number_of_completed_combat}" +
                    $"You can choose {self.can_choose_persistent() && self.new_persistent == undefined ? "1" : "0"} more trait to carry into your new life\n" +
                    $"You can choose {self.to_discard == undefined ? "1" : "0"} trait to stop carrying it to your new life";
game_summary = scribble(self.game_summary_text)
    .align(fa_center, fa_top);
self.game_summary.draw(self.x, self.y - 0.35 * room_height);