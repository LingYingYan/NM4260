page_open = false;

if (!instance_exists(obj_ele_reaction)) {
	show_debug_message("creating new obj_ele_reaction at room start")
	ele_tut = instance_create_layer(0,0,"Instances", obj_ele_reaction);
}