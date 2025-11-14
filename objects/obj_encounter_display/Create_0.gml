function initialize_encounter(data) {
    encounter_data = data;
    name = encounter_data.name;
    description = encounter_data.description;
    options = encounter_data.options;

    show_debug_message("Encounter initialized: " + name);
}

options = []
button_generated = false;

spr_x_padding = room_width / 3;
spr_y_padding = room_height / 4;
spr_w = room_width - spr_x_padding * 2;
spr_h = room_height / 2;