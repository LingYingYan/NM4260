//draw_tooltip_at(
//    "[i]The Prophet[/i] is a Rogue-lite deckbuilder game. You must survive the dungeon by collecting [b]spell cards[/b] and [b]relics[/b] and use them wisely to defeat the vicious enemies.\n\nWhen casting spells from your cards, [b]Elemental Marks[/b] can apply to you or your enemy. These Marks can react to one another to trigger devastating effects so be careful about it when you use a card!\n\nMany keywords and game elements in [i]The Prophet[/i] can be hovered over to show a tooltip. Try it when you need help to understand something in this game!\n\n(Click anywhere to close)",
//    fa_left, fa_top, x_gui, y_gui
//);
//change bg
draw_sprite_stretched(spr_notice_h, 0, box_x, box_y, box_w, box_h);
scribble_text.draw(room_width / 2 - self.scribble_text.get_width() / 2, self.box_y + 200);
