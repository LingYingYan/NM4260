if (self.is_loaded) {
    exit;
}

var is_not_yet_loaded = !res_loader_destruction_cards.is_loaded || 
                        !res_loader_restoration_cards.is_loaded ||
                        !res_loader_alteration_cards.is_loaded ||
                        !res_loader_enchantment_cards.is_loaded;
if (is_not_yet_loaded) {
    exit;
}

self.add_card(res_loader_destruction_cards.loaded_map);
self.add_card(res_loader_restoration_cards.loaded_map);
self.add_card(res_loader_alteration_cards.loaded_map);
self.add_card(res_loader_enchantment_cards.loaded_map);
self.loaded = array_concat(
    res_loader_destruction_cards.loaded, 
    res_loader_restoration_cards.loaded, 
    res_loader_alteration_cards.loaded,
    res_loader_enchantment_cards.loaded
);

self.total_weight = res_loader_destruction_cards.total_weight +
                    res_loader_restoration_cards.total_weight +
                    res_loader_alteration_cards.total_weight +
                    res_loader_enchantment_cards.total_weight;

self.is_loaded = true;
res_loader_enemies.load();