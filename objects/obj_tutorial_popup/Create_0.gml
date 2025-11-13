text = scribble("Tutorial?")
	.align(fa_center, fa_middle)
	.starting_format("fnt_default_large", c_black)
	.scale(3)

yes_option = scribble("Yes!")
	.align(fa_center, fa_middle)
	.starting_format("fnt_default_large", c_black);

no_option = scribble("No!")
	.align(fa_center, fa_middle)
	.starting_format("fnt_default_large", c_black);

popup_w = 800;
popup_h = 600;
popup_x = (room_width - popup_w) / 2;
popup_y = (room_height - popup_h) / 2;

//option buttons
button_width = 100;
button_height = 50;

yes_button_x1 = popup_x + popup_w/4;
yes_button_y1 = popup_y + popup_h/2;
yes_button_x2 = yes_button_x1 + button_width;
yes_button_y2 = yes_button_y1 + button_height;

no_button_x1 = popup_x + popup_w - popup_w/4 - button_width;
no_button_y1 = popup_y + popup_h/2;
no_button_x2 = no_button_x1 + button_width;
no_button_y2 = no_button_y1 + button_height;

depth = -15000;