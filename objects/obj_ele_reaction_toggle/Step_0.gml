if (!global.ele_react_tut_shown && global.is_tut && room == rm_battle) {
	ele_tut = instance_create_layer(0,0,"Instances", obj_ele_reaction);
	ele_tut.visible = true;
	global.ele_react_tut_shown = true
	ele_tut.is_open = true;
	page_open = true;
}

if (instance_exists(obj_ele_reaction)) {
	if (page_open) {
		with (obj_ele_reaction) { 
			is_open = true;
			visible = true;
		}
		
	} else {
		with (obj_ele_reaction) { 
			is_open = false;
			visible = false;
		}
	}
	//with (obj_ele_reaction) {
	//	if (is_open == false) {
	//		is_open = true;
	//		visible = true;
	//		other.page_open = true;
	//		show_debug_message("Opening element reaction manual");
	//	} else {
	//		is_open = false;
	//		visible = false;
	//		other.page_open = false;
	//	}
	//}
}