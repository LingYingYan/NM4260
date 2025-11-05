var text = ""
switch (label_scenario) {
	case "encounter_map":
		text = scribble("This is an encounter room [spr_encounter]. Make careful decisions...")
				.wrap(200); break;
	case "enemy_map":
		text = scribble("This is an enemy room [spr_enemy].")
				.wrap(200); break;
	case "discover":
		text = scribble("Some discovered rooms are not revealed")
				.wrap(200);break;
}

text.draw(x, y, typist);