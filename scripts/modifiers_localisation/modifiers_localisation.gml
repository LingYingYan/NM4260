function get_modifier_display_name(key, value) {
    switch (key) {
        case "spell_resistance":
            return $"{signed_number(-value, false)}% damage received from all cards";
        case "water_power_mult":
            return $"{make_mark("mark_water").get_label()} card power {signed_number(value)}%";
        case "fire_power_mult":
            return $"{make_mark("mark_fire").get_label()} card power {signed_number(value)}%";
        case "grass_power_mult":
            return $"{make_mark("mark_grass").get_label()} card power {signed_number(value)}%";
        case "lightning_power_mult":
            return $"{make_mark("mark_lightning").get_label()} card power {signed_number(value)}%";
        case "ice_power_mult":
            return $"{make_mark("mark_ice").get_label()} card power {signed_number(value)}%";
        case "restoration_power_mult":
            return $"[b]Restoration[/b] card power {signed_number(value)}%";
        case "destruction_power_mult":
            return $"[b]Destruction[/b] card power {signed_number(value)}%";
        case "enchantment_power_mult":
            return $"[b]Enchantment[/b] card power {signed_number(value)}%";
        case "spell_power_mult":
            return $"All card power {signed_number(value)}%";
        case "poison_resistance":
            return $"{signed_number(value)}% chance to resist {make_status("Poison", 0).get_label()}";
        case "burn_resistance":
            return $"{signed_number(value)}% chance to resist {make_status("Burn", 0).get_label()}";
        case "bleed_resistance":
            return $"{signed_number(value)}% chance to resist {make_status("Bleed", 0).get_label()}";
        case "paralysed_resistance":
            return $"{signed_number(value)}% chance to resist {make_status("Paralysed", 0).get_label()}";
        case "frozen_resistance":
            return $"{signed_number(value)}% chance to resist {make_status("Frozen", 0).get_label()}";
        case "strength_resistance":
            return $"{signed_number(value, false)}% chance to resist {make_status("Strength", 0).get_label()}";
        case "coalesence_resistance":
            return $"{signed_number(value, false)}% chance to resist {make_status("Coalesence", 0).get_label()}";
        case "water_weakness":
            return $"{signed_number(value, false)}% effect received from {make_mark("mark_water").get_label()}";
        case "fire_weakness":
            return $"{signed_number(value, false)}% effect received from {make_mark("mark_fire").get_label()}";
        case "grass_weakness":
            return $"{signed_number(value, false)}% effect received from {make_mark("mark_grass").get_label()}";
        case "lightning_weakness":
            return $"{signed_number(value, false)}% effect received from {make_mark("mark_lightning").get_label()}";
        case "ice_weakness":
            return $"{signed_number(value, false)}% effect received from {make_mark("mark_ice").get_label()}";
    }
}

function signed_number(n, good_if_positive = true) {
    if (good_if_positive) {
        return n >= 0 ? $"[c_green]+{n}[/c]" : $"[c_red]{n}[/c]";
    }
    
    return n >= 0 ? $"[c_red]+{n}[/c]" : $"[c_green]{n}[/c]";
}
