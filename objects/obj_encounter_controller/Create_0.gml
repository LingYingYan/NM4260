var e = choose_array(global.encounter_cases);
show_debug_message($"Encounter scenario chosen: {e}");
var encounter_disp = instance_create_layer(0, 0, "Instances", obj_encounter_display);
encounter_disp.initialize_encounter(e);