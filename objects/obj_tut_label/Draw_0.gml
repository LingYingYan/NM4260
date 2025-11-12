var text = ""
switch (label_scenario) {
	case "encounter_map":
		text = scribble($"This is an [b]encounter[/b] room. Make careful decisions...")
				.wrap(200); break;
	case "enemy_map":
		text = scribble($"This is an [b]enemy[/b] room.")
				.wrap(200); break;
	case "discover":
		text = scribble("Some discovered rooms are not revealed")
				.wrap(200);break;
}

text.draw(x, y, typist);