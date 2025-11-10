visible = true;
popup_w = 800;
popup_h = 700;
popup_x = (room_width - popup_w) / 2;
popup_y = (room_height - popup_h) / 2;

// Text content
text_title = "Help";
//text_designers = "Designers: Puyu, Jiayi";
//text_developers = "Developers: Lingying, Puyu";
//text_artists = "Artists: Ashley, Jiayi";
//text_QA = "QA: Meihan, Ashley";
//text_producer = "Producer: Meihan";
text_help = scribble("[i]The Prophet[/i] is a Rogue-lite deckbuilder game. You must survive the dungeon by collecting [b]spell cards[/b] and [b]relics[/b] and use them wisely to defeat the vicious enemies.\n\nWhen casting spells from your cards, [b]Elemental Marks[/b] can apply to you or your enemy. These Marks can react to one another to trigger devastating effects so be careful about it when you use a card!\n\nMany keywords and game elements in [i]The Prophet[/i] can be hovered over to show a tooltip. Try it when you need help to understand something in this game!")
			.starting_format("font_game_text", c_white)
			.align(fa_center, fa_middle)
			.scale(1.5)
			.wrap(720);


// Close button rectangle
close_size = 40;
close_x1 = popup_x + popup_w - close_size - 10;
close_y1 = popup_y + 10;
close_x2 = close_x1 + close_size;
close_y2 = close_y1 + close_size;

// Fade-in
alpha = 0;
fade_in_speed = 0.05;

depth = -10000;
