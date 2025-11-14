//if (! page_open) {
//	with (obj_ele_reaction) {
//		 is_open = true;
//		 visible = true;
//	}
//	page_open = true;
	
//} else {
//	with (obj_ele_reaction) {
//		 is_open = false;
//		 visible = false;
//	}
//	page_open= false;
//}

if (!instance_exists(obj_ele_reaction)) {
	show_debug_message("creating new obj_ele_reaction when pressing left")
	var ele = instance_create_layer(0,0,"Instances", obj_ele_reaction);
	ele.is_open = true;
	page_open = true;
}

//with (obj_ele_reaction) {
//	if (is_open == false) {
//		is_open = true;
//		visible = true;
//		other.page_open = true;
//		show_debug_message("Opening element reaction manual");
//	} 
//	//else {
//	//	is_open = false;
//	//	visible = false;
//	//	other.page_open = false;
//	//	instance_destroy();
//	//}
//}