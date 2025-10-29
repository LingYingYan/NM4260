if (is_callable(option_effect) && !alarm_setted) {
	show_debug_message($"Choosing option: {option_name}");
	var msg = instance_create_layer(0, 0, "Instances", obj_popup_message);
	msg.message_text = option_message;
	msg.function_to_run = option_effect;
	//option_effect();
	//show_message(option_message);
	alarm_setted = true;
	alarm[0] = 200 // 3+ second
	
}