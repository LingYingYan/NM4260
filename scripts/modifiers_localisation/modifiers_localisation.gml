function get_modifier_display_name(key) {
    switch (key) {
        case "water_power_mult":
            return $"{make_mark("mark_water").get_label()} card power";
        case "fire_power_mult":
            return $"{make_mark("mark_fire").get_label()} card power";
        case "grass_power_mult":
            return $"{make_mark("mark_grass").get_label()} card power";
        case "lightning_power_mult":
            return $"{make_mark("mark_lightning").get_label()} card power";
        case "ice_power_mult":
            return $"{make_mark("mark_ice").get_label()} card power";
        case "restoration_power_mult":
            return $"[b]Restoration[/b] card power";
        case "destruction_power_mult":
            return $"[b]Destruction[/b] card power";
        case "enchantment_power_mult":
            return $"[b]Enchantment[/b] card power";
        case "spell_power_mult":
            return $"All card power";
        case "poison_resistance":
            return $"Chance to resist {make_status("Poison", 0).get_label()}";
        case "burn_resistance":
            return $"Chance to resist {make_status("Burn", 0).get_label()}";
        case "bleed_resistance":
            return $"Chance to resist {make_status("Bleed", 0).get_label()}";
        case "paralysed_resistance":
            return $"Chance to resist {make_status("Paralysed", 0).get_label()}";
        case "frozen_resistance":
            return $"Chance to resist {make_status("Frozen", 0).get_label()}";
        case "strength_resistance":
            return $"Chance to resist {make_status("Strength", 0).get_label()}";
        case "coalesence_resistance":
            return $"Chance to resist {make_status("Coalesence", 0).get_label()}";
        case "water_weakness":
            return $"Damage received from {make_mark("mark_water").get_label()}";
        case "fire_weakness":
            return $"Damage received from {make_mark("mark_fire").get_label()}";
        case "grass_weakness":
            return $"Damage received from {make_mark("mark_grass").get_label()}";
        case "lightning_weakness":
            return $"Damage received from {make_mark("mark_lightning").get_label()}";
        case "ice_weakness":
            return $"Damage received from {make_mark("mark_ice").get_label()}";
    }
}