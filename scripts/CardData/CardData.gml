/**
 * Function Description
 * @param {string} card_id Description
 * @param {string} card_type Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 * @param {real} mark_count description
 */
function CardData(
    card_id, card_type, card_name, card_sprite, card_rarity,
    mark_id, mark_count
) constructor {
    uid = card_id;
    type = card_type;
    name = card_name;
    sprite = card_sprite;
    rarity = card_rarity;
    mark = make_mark(mark_id);
    mark_multiplicity = mark_count;
    
    get_weight = function() {
        return 5 - self.rarity;
    }
    
    get_magnitude = function(raw, modifier) {
        var value = floor(raw * max(0, (100 + modifier) / 100));
        if (value == 0 && modifier > -100) {
            return 1;
        }
        
        return value;
    }
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) { }
    
    /**
     * @desc Collides with another card
     * @param {Struct.CardData} other_card The other card
     */
    collide = function(other_card) { }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @return {string} The card description
     */
    describe = function(visibility) {
        return "?";
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.CardData} The clone
     */
    clone = function() {
        return new CardData(
            self.uid, self.type, self.name, self.sprite, self.rarity,
            self.mark, self.mark_multiplicity
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
    mark_id, mark_count, attack_damage
) : CardData(
    card_id, "Destruction", card_name, card_sprite, card_rarity, 
    mark_id, mark_count
) constructor {
    damage = attack_damage;
    is_nullified = false;
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) {
        if (target == noone || target == undefined) { 
            show_debug_message("Attacked");   
            return;     
        }
            
        var old_hp = target.hp;
        if (!self.is_nullified) {
            var dmg = self.get_magnitude(self.damage, instigator.modifiers.card_effectiveness);
            var eliminated = min(target.modifiers.shield, dmg);
            dmg -= eliminated;
            target.modifiers.shield -= eliminated;
            target.add_status(new Shield(-eliminated));
            target.hp -= max(0, dmg);
            target.hp = max(target.hp, 0);
            self.mark.on_apply(target, self.get_magnitude(self.mark_multiplicity, instigator.modifiers.card_effectiveness));
            show_debug_message($"Attack {target}: HP {old_hp} -> {target.hp}");
        }
    }
    
    /**
     * @desc Collides with another card
     * @param {Struct.CardData} other_card The other card
     */
    collide = function(other_card) {
        if (typeof(other_card) == nameof(DefensiveCardData)) {
            if (other_card.mark == self.mark) {
                self.is_nullified = true;
            }
        }
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.DestructionCardData} The clone
     */
    clone = function() {
        return new DestructionCardData(
            self.uid, self.name, self.sprite, self.rarity,
            self.mark.uid, self.mark_multiplicity, self.damage
        );
    }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @return {string} The card description
     */
    describe = function(visibility) {
        if (visibility >= 4) {
            return $"Deals {self.damage} {self.mark.type} damage to target\n" + 
                   $"Applies {self.mark.type} Mark × {self.mark_multiplicity} to target";
        }
        
        if (visibility >= 3) {
            return $"Deals {self.damage} {self.mark.type} damage to target"
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
 * @param {string} removed_mark_id Description
 * @param {real} removed_mark_count Description
 * @param {real} heal_amount Description
 */
function RestorationCardData(
    card_id, card_name, card_sprite, card_rarity, 
    mark_id, mark_count, removed_mark_id, removed_mark_count,
    heal_amount
) : CardData(
    card_id, "Restoration", card_name, card_sprite, card_rarity, 
    mark_id, mark_count
) constructor {
    amount = heal_amount;
    mark_id_to_remove = removed_mark_id;
    mark_count_to_remove = removed_mark_count;
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) {
        if (instigator == noone || instigator == undefined) { 
            show_debug_message("Restored");   
            return;     
        }
            
        var old_hp = instigator.hp;
        var effect_modifier = instigator.modifiers.card_effectiveness;
        instigator.hp += self.get_magnitude(self.amount, effect_modifier);
        instigator.hp = min(instigator.hp, instigator.max_hp);
        show_debug_message($"Restore {instigator}: HP {old_hp} -> {instigator.hp}");
        var mark_remove_count = self.get_magnitude(self.mark_count_to_remove, effect_modifier);
        if (mark_remove_count > 0) {
            instigator.add_marks(self.mark_id_to_remove, -mark_remove_count);
        }
            
        self.mark.on_apply(instigator, self.get_magnitude(self.mark_multiplicity, effect_modifier)); 
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
     * @return {string} The card description
     */
    describe = function(visibility) {
        if (visibility >= 4) {
            var desc = "";
            if (self.amount > 0) {
                desc += $"Heals {self.amount} HP for caster";
            }
            
            if (self.mark_id_to_remove != "" && self.mark_count_to_remove > 0) {
                var removed_mark_data = make_mark(self.mark_id_to_remove);
                if (desc != "") {
                    desc += "\n";
                }
                desc += $"Removes {removed_mark_data.type} × {self.mark_count_to_remove} Mark from caster";
            }
            
            return desc + $"\nApplies {self.mark.type} × {self.mark_multiplicity} Mark to caster";
        }
        
        if (visibility >= 3) {
            var desc = "";
            if (self.amount > 0) {
                desc += $"Heals {self.amount} for caster";
            }
            
            if (self.mark_id_to_remove != "" && self.mark_count_to_remove > 0) {
                var removed_mark_data = make_mark(self.mark_id_to_remove);
                if (desc != "") {
                    desc += "\n";
                }
                
                desc += $"\nRemoves {removed_mark_data.type} Mark from caster";
            }
            
            return desc + $"\nApplies {self.mark.type} Mark to caster";
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
 * @param {string} transform_from_id Description
 */
function AlterationCardData(
    card_id, card_name, card_sprite, card_rarity, 
    mark_id, mark_count, transform_from_id
) : CardData(
    card_id, "Alteration", card_name, card_sprite, card_rarity, 
    mark_id, mark_count
) constructor {
    transform_from = transform_from_id;
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) {
        if (target == noone || target == undefined) { 
            show_debug_message("Altered");   
            return;     
        }
            
        var old_count = target.count_mark(self.transform_from);
        var effect_modifier = instigator.modifiers.card_effectiveness;
        target.add_marks(self.transform_from, -old_count);
        self.mark.on_apply(target, self.get_magnitude(self.mark_multiplicity, effect_modifier) * old_count);
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
 * @param {real} status_level
 */
function EnchantmentCardData(
    card_id, card_name, card_sprite, card_rarity, 
    mark_id, mark_count, status_data, status_level
) : CardData(
    card_id, "Enchantment", card_name, card_sprite, card_rarity, 
    mark_id, mark_count
) constructor {
    status = status_data;
    level = status_level;
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) {
        if (target == noone || target == undefined) { 
            show_debug_message("Enchanted");   
            return;     
        }
            
        instigator.modifiers.shield += self.defence_amount;
        self.mark.on_apply(instigator, self.mark_multiplicity); 
    }
    
    collide = function(other_card) {
        if (typeof(other_card) == nameof(DestructionCardData)) {
            if (other_card.mark == self.mark) {
                other_card.effectiveness = 0;
            }
        }
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.EnchantmentCardData} The clone
     */
    clone = function() {
        return new EnchantmentCardData(
            self.uid, self.name, self.sprite, self.rarity,
            self.mark.uid, self.mark_multiplicity, self.status, self.level
        );
    }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @return {string} The card description
     */
    describe = function(visibility) {
        if (visibility >= 4) {
            return $"Adds {self.status.name} × {self.level} to caster\n" + 
                   $"Applies {self.mark.type} Mark × {self.mark_multiplicity} to caster";
        }
        
        if (visibility >= 3) {
            return $"A {self.mark.type} {self.type} card\n" + 
                   $"Adds {self.status.name} × {self.level} to caster";
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

