/**
 * Function Description
 * @param {string} card_id Description
 * @param {string} card_type Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 * @param {real} mark_count description
 * @param {array<string>} special_effects
 */
function CardData(
    card_id, card_type, card_name, card_sprite, card_rarity,
    mark_id, mark_count, special_effects = []
) constructor {
    uid = card_id;
    type = card_type;
    name = card_name;
    sprite = card_sprite;
    rarity = card_rarity;
    mark = make_mark(mark_id);
    mark_multiplicity = mark_count;
    keywords = special_effects;
    is_offensive = true;
    is_nullified = false;
    
    get_modifier_by_mark = function(mult, instigator, target) {
        switch (self.mark.type) {
            case "Fire":
                mult += (instigator.modifiers[$ "fire_power_mult"] ?? 0);
                mult += (target.modifiers[$ "fire_weakness_mult"] ?? 0);
                break;
            case "Water":
                mult += (instigator.modifiers[$ "water_power_mult"] ?? 0);
                mult += (target.modifiers[$ "water_weakness_mult"] ?? 0);
                break;
            case "Grass":
                mult += (instigator.modifiers[$ "grass_power_mult"] ?? 0);
                mult += (target.modifiers[$ "grass_weakness_mult"] ?? 0);
                break;
            case "Lightning":
                mult += (instigator.modifiers[$ "lightning_power_mult"] ?? 0);
                mult += (target.modifiers[$ "lightning_weakness_mult"] ?? 0);
                break;
            case "Ice":
                mult += (instigator.modifiers[$ "ice_power_mult"] ?? 0);
                mult += (target.modifiers[$ "ice_weakness_mult"] ?? 0);
                break;
        }

        return mult
    }
    
    get_weight = function() {
        return 5 - self.rarity;
    }
    
    /**
     * @desc Evaluates mark application count
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    get_mark_application_count = function(instigator, target) {
        if (instigator == undefined || target == undefined) {
            return self.mark_multiplicity;
        }
        
        return instigator.modifiers.paralysed ? max(0, floor(self.mark_multiplicity * 0.75)) : self.mark_multiplicity;
    }
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) { }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     * @return {string} The card description
     */
    describe = function(visibility, instigator, target) {
        return "?";
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.CardData} The clone
     */
    clone = function() {
        return new CardData(
            self.uid, self.type, self.name, self.sprite, self.rarity,
            self.mark.uid, self.mark_multiplicity
        );
    }
}

/**
 * Function Description
 * @param {string} card_id Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 * @param {real} mark_count Description
 * @param {real} attack_damage Description
 */
function DestructionCardData(
    card_id, card_name, card_sprite, card_rarity, 
    mark_id, mark_count, attack_damage, special_effects = []
) : CardData(
    card_id, "Destruction", card_name, card_sprite, card_rarity, 
    mark_id, mark_count, special_effects
) constructor {
    damage = attack_damage;
    
    /**
     * @desc Computes damage
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    get_damage = function(instigator, target) {
        if (instigator == undefined || target == undefined) {
            return self.damage;
        }
        
        var dmg = self.damage;
        var mult = 100;
        if (instigator.modifiers.paralysed) {
            mult -= 25;
        } 
        
        if (target.modifiers.bleeding) {
            mult += 25;
        }
        
        mult = self.get_modifier_by_mark(mult, instigator, target);
        mult += (instigator.modifiers[$ "destruction_power_mult"] ?? 0);
        return max(0, floor(dmg * mult / 100));
    }
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) {
        if (target == undefined || self.is_nullified) { 
            return;     
        }
            
        // Calculate modified damage
        var dmg = self.get_damage(instigator, target);
        
        // Eliminate shields
        var eliminated_shields = min(target.modifiers.shield, dmg);
        dmg -= eliminated_shields;
        target.add_status(new Shield(-eliminated_shields));
        
        // Apply damage
        target.hp = max(target.hp - max(0, dmg), 0);
        target.hp = max(target.hp, 0);
        
        // Apply mark
        if (self.mark != undefined) {
            self.mark.on_apply(target, self.get_mark_application_count(instigator, target));
        }
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.DestructionCardData} The clone
     */
    clone = function() {
        return new DestructionCardData(
            self.uid, self.name, self.sprite, self.rarity,
            self.mark.uid, self.mark_multiplicity, 
            self.damage, self.keywords
        );
    }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     * @return {string} The card description
     */
    describe = function(visibility, instigator, target) {
        var dmg = self.get_damage(instigator, target);
        var dmg_text = stylise_numeric_text(dmg, self.damage);
        var mark_application_count = self.get_mark_application_count(instigator, target);
        var mark_application_text = stylise_numeric_text(mark_application_count, self.mark_multiplicity);
        
        if (visibility >= 4) {
            return $"{self.mark.get_label()} [b]{self.type}[/b]\n" +
                   $"[bi]Target[/bi]:\n" + 
                   $"  Receives {dmg_text} damage\n" + 
                   $"  {self.mark.get_label()} Mark + {mark_application_text}";
        }
        
        if (visibility >= 3) {
            return $"{self.mark.get_label()} [b]{self.type}[/b]\n" + 
                   $"[i]Target[/i]:\n" + 
                   $"  Receives {dmg_text} damage";
        }
        
        if (visibility >= 2) {
            return $"{self.mark.get_label()} [b]{self.type}[/b]";
        }
        
        if (visibility >= 1) {
            return $"{self.mark.get_label()}";
        }
        
        return "";
    }
}

/**
 * Function Description
 * @param {string} card_id Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 * @param {real} mark_count Description
 * @param {string} removed_mark_id Description
 * @param {real} removed_mark_count Description
 * @param {real} heal_amount Description
 */
function RestorationCardData(
    card_id, card_name, card_sprite, card_rarity, 
    mark_id, mark_count, removed_mark_id, removed_mark_count,
    heal_amount, special_effects = []
) : CardData(
    card_id, "Restoration", card_name, card_sprite, card_rarity, 
    mark_id, mark_count, special_effects
) constructor {
    amount = heal_amount;
    mark_id_to_remove = removed_mark_id;
    mark_count_to_remove = removed_mark_count;
    is_offensive = false;
    
    /**
     * @desc Computes healing
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    get_heal = function(instigator, target) {
        if (instigator == undefined || target == undefined) {
            return self.amount;
        }
        
        var heal = self.amount;
        var mult = 100;
        if (instigator.modifiers.paralysed) {
            mult -= 25;
        }
        
        mult = self.get_modifier_by_mark(mult, instigator, target);
        mult += (instigator.modifiers[$ "restoration_power_mult"] ?? 0);
        return max(0, floor(heal * mult / 100));
    }
    
    /**
     * @desc Computes mark removal
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    get_mark_removal = function(instigator, target) {
        if (instigator == undefined || target == undefined) {
            return self.mark_count_to_remove;
        }
        
        var count = self.mark_count_to_remove;
        var mult = 100;
        if (instigator.modifiers.paralysed) {
            mult -= 25;
        }
        
        mult = self.get_modifier_by_mark(mult, instigator, target);
        mult += (instigator.modifiers[$ "restoration_power_mult"] ?? 0);
        return max(0, floor(self.mark_count_to_remove * mult / 100));
    }
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) {
        if (instigator == undefined || self.is_nullified) { 
            return;     
        }
            
        instigator.hp = min(instigator.hp + self.get_heal(instigator, target), instigator.max_hp);
        var mark_remove_count = self.get_mark_removal(instigator, target);
        if (mark_remove_count > 0) {
            instigator.add_marks(self.mark_id_to_remove, -mark_remove_count);
        }
           
        if (self.mark != undefined) { 
            self.mark.on_apply(instigator, self.get_mark_application_count(instigator, target)); 
        }
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.RestorationCardData} The clone
     */
    clone = function() {
        return new RestorationCardData(
            self.uid, self.name, self.sprite, self.rarity,
            self.mark.uid, self.mark_multiplicity, self.mark_id_to_remove, self.mark_count_to_remove,
            self.amount
        );
    }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     * @return {string} The card description
     */
    describe = function(visibility, instigator, target) {
        var heal = self.get_heal(instigator, target);
        var heal_text = stylise_numeric_text(heal);
        var remove = self.get_mark_removal(instigator, target);
        var remove_text = stylise_numeric_text(remove);
        var mark_application_count = self.get_mark_application_count(instigator, target);
        var mark_application_text = stylise_numeric_text(mark_application_count, self.mark_multiplicity);
        
        if (visibility >= 4) {
            var desc = $"{self.mark.get_label()} [b]{self.type}[/b]\n[bi]Caster:[/bi]";
            if (self.amount > 0) {
                desc += $"\n  Restores {heal_text} HP";
            }
            
            if (self.mark_id_to_remove != "" && self.mark_count_to_remove > 0) {
                var removed_mark_data = make_mark(self.mark_id_to_remove);
                desc += $"\n  {removed_mark_data.get_label()} Mark - {remove_text}";
            }
            
            return desc + $"\n  {self.mark.get_label()} Mark + {mark_application_text}";
        }
        
        if (visibility >= 3) {
            var desc = $"{self.mark.get_label()} [b]{self.type}[/b]\n[bi]Caster:[/bi]";
            if (self.amount > 0) {
                desc += $"Heals {self.amount} for caster";
            }
            
            if (self.amount > 0) {
                desc += $"\n  Restores {heal_text} HP";
            }
            
            if (self.mark_id_to_remove != "" && self.mark_count_to_remove > 0) {
                var removed_mark_data = make_mark(self.mark_id_to_remove);
                desc += $"\n  {removed_mark_data.get_label()} Mark - ?";
            }
            
            return desc + $"\n  {self.mark.get_label()} Mark + ?";
        }
        
        if (visibility >= 2) {
            return $"{self.mark.get_label()} [b]{self.type}[/b]";
        }
        
        if (visibility >= 1) {
            return $"{self.mark.get_label()}";
        }
        
        return "";
    }
}

/**
 * DEPRECATED
 * @param {string} card_id Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 * @param {real} mark_count Description
 * @param {string} transform_from_id Description
 */
function AlterationCardData(
    card_id, card_name, card_sprite, card_rarity, 
    mark_id, mark_count, transform_from_id, special_effects = []
) : CardData(
    card_id, "Alteration", card_name, card_sprite, card_rarity, 
    mark_id, mark_count, special_effects
) constructor {
    transform_from = transform_from_id;
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) {
        if (target == noone || target == undefined || self.is_nullified) { 
            show_debug_message("Altered");   
            return;     
        }
            
        var old_count = target.count_mark(self.transform_from);
        var effect_modifier = instigator.modifiers.card_effectiveness;
        target.add_marks(self.transform_from, -old_count);
        if (self.mark != undefined) {
            self.mark.on_apply(target, old_count);
        }
        
        show_debug_message($"Alter {target}: {make_mark(self.transform_from).type} × {old_count} -> {self.mark} × {target.count_mark(self.mark.uid)}");
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.AlterationCardData} The clone
     */
    clone = function() {
        return new AlterationCardData(
            self.uid, self.name, self.sprite, self.rarity,
            self.mark.uid, self.mark_multiplicity, self.transform_from
        );
    }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @return {string} The card description
     */
    describe = function(visibility) {
        var transform_from_mark_data = make_mark(self.transform_from);
        if (visibility >= 4) {
            return $"Transforms each {transform_from_mark_data.type} Mark to {self.mark.type} Mark × {self.mark_multiplicity} on target";
        }
        
        if (visibility >= 3) {
            return $"Transforms {transform_from_mark_data.type} Mark to {self.mark.type} Mark on target";
        }
        
        if (visibility >= 2) {
            return $"A {self.mark.type} {self.type} card";
        }
        
        if (visibility >= 1) {
            return $"A {self.mark.type} card";
        }
        
        return "";
    }
}

/**
 * Function Description
 * @param {string} card_id Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 * @param {real} mark_count Description
 * @param {Struct.Status} status_data
 */
function EnchantmentCardData(
    card_id, card_name, card_sprite, card_rarity, 
    mark_id, mark_count, status_data, special_effects = []
) : CardData(
    card_id, "Enchantment", card_name, card_sprite, card_rarity, 
    mark_id, mark_count, special_effects
) constructor {
    status = status_data;
    is_offensive = false;
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) {
        if (target == noone || target == undefined || self.is_nullified) { 
            show_debug_message("Enchanted");   
            return;     
        }
            
        var effect_modifier = instigator.modifiers.card_effectiveness;
        var status = make_status(self.status.name, self.get_magnitude(self.status.level, effect_modifier))
        instigator.add_status(status);
        if (self.mark.type != undefined) {
            self.mark.on_apply(instigator, self.get_magnitude(self.mark_multiplicity, effect_modifier));
        } 
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.EnchantmentCardData} The clone
     */
    clone = function() {
        return new EnchantmentCardData(
            self.uid, self.name, self.sprite, self.rarity,
            self.mark == undefined ? "none" : self.mark.uid, self.mark_multiplicity, self.status
        );
    }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @return {string} The card description
     */
    describe = function(visibility) {
        if (visibility >= 4) {
            return $"{self.mark.get_label()} [b]{self.type}[/b]\n[bi]Caster:[/bi]" + 
                   $"  {self.status.get_label()} + {self.status.level}";
        }
        
        if (visibility >= 3) {
            return $"{self.mark.get_label()} [b]{self.type}[/b]\n[bi]Caster:[/bi]" + 
                   $"  {self.status.get_label()} + ?";
        }
        
        if (visibility >= 2) {
            return $"{self.mark.get_label()} [b]{self.type}[/b]"
        }
        
        if (visibility >= 1) {
            return $"{self.mark.get_label()}";
        }
        
        return "";
    }
}

/**
 * A card that applies a status effect to its target.
 * @param {string} card_id Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 * @param {real} mark_count Description
 * @param {Struct.Status} status_data
 * @param {array} [special_effects] description
 */
function CurseCardData(
    card_id, card_name, card_sprite, card_rarity, 
    mark_id, mark_count, 
    status_data, special_effects = []
) : CardData(
    card_id, "Curse", card_name, card_sprite, card_rarity, 
    mark_id, mark_count, special_effects
) constructor {
            
}


/**
 * Function Description
 * @param {Struct.GameCharacterData} player_data Description
 * @param {Struct.CardData} player_card Description
 * @param {Struct.GameCharacterData} enemy_data Description
 * @param {Struct.CardData} enemy_card Description
 */
function apply_special_effects(player_data, player_card, enemy_data, enemy_card) {
    apply_ward(player_card, enemy_card);
}

/**
 * Function Description
 * @param {Struct.CardData} player_card Description
 * @param {Struct.CardData} enemy_card Description
 */
function apply_ward(player_card, enemy_card) {
    if (player_card == undefined || player_card == noone || enemy_card == undefined || enemy_card == noone) {
        return;
    }
    
    if (array_contains(player_card.keywords, "Ward") && enemy_card.is_offensive) {
        enemy_card.is_nullified = true;
    }
    
    if (array_contains(enemy_card.keywords, "Ward") && player_card.is_offensive) {
        player_card.is_nullified = true;
    }
}

