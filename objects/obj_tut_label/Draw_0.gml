var text = ""
switch (label_scenario) {
	case "encounter_map":
		text = scribble($"This is an [b]encounter[/b] room. Make careful decisions...")
				.wrap(200); break;
	case "enemy_map":
		text = scribble($"This is an [b]enemy[/b] room.")
				.wrap(200); break;
	case "discover":
		text = scribble("Some [b]discovered[/b] rooms are [b]not revealed[/b].")
				.wrap(200);break;
	case "purchase":
		text = scribble("Use [b]Vision[/b] to purchase [b]Cards & Relics[/b].")
				.wrap(200); break;
	case "drawer":
		text = scribble("Click to view your [b]current card deck[/b]. You can spend [b]Vision[/b] to remove one Card in [b]Shops[/b]")
				.wrap(200); break;
	case "ele_reaction_help":
		text = scribble("Click to view [b]element reaction[/b]")
				.wrap(200); break;
	case "remember_room":
		text = scribble("Long press a room to [b]remember[/b] it")
				.wrap(200); break;
}

text.draw(x, y, typist);