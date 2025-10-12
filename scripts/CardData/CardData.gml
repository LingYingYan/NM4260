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
    mark = res_loader_marks[? mark_id];
    mark_multiplicity = mark_count;

    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    apply = function(instigator, target) { }
    
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
        target.hp -= self.damage;
        target.hp = max(target.hp, 0);
        show_debug_message($"Attack {target}: HP {old_hp} -> {target.hp}");
        self.apply_marks(instigator, target); 
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.DestructionCardData} The clone
     */
    clone = function() {
        return new DestructionCardData(
            self.uid, self.name, self.sprite, self.rarity,
            self.mark, self.mark_multiplicity, self.damage
        );
    }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @return {string} The card description
     */
    describe = function(visibility) {
        if (visibility >= 4) {
            return $"A {self.mark.type} {self.type} card\n" + 
                   $"Deals {self.damage} {self.mark.type} damage to you\n" + 
                   $"Applies {self.mark.type} Mark × {self.mark_multiplicity} to you";
        }
        
        if (visibility >= 3) {
            return $"A {self.mark.type} {self.type} card\n" + 
                   $"Deals {self.damage} {self.mark.type} damage to you"
        }
        
        if (visibility >= 2) {
            return $"A {self.mark.type} {self.type} card";
        }
        
        if (visibility >= 1) {
            return $"A {self.mark.type} card";
        }
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
        instigator.hp += self.amount;
        instigator.hp = min(instigator.hp, instigator.max_hp);
        show_debug_message($"Restore {instigator}: HP {old_hp} -> {instigator.hp}");
        instigator.add_marks(self.mark_id_to_remove, -self.mark_count_to_remove);
        self.apply_marks(instigator, instigator); 
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.RestorationCardData} The clone
     */
    clone = function() {
        return new RestorationCardData(
            self.uid, self.name, self.sprite, self.rarity,
            self.mark, self.mark_multiplicity, self.mark_id_to_remove, self.mark_count_to_remove,
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
            var desc = $"A {self.mark.type} {self.type} card";
            if (self.amount > 0) {
                desc += $"\nHeals {self.amount} for caster";
            }
            
            if (self.mark_id_to_remove != "" && self.mark_count_to_remove > 0) {
                var removed_mark_data = res_loader_marks.loaded[? self.mark_id_to_remove];
                desc += $"\nRemoves {removed_mark_data.type} × {self.mark_count_to_remove} Mark from caster";
            }
            
            return desc + $"\nApplies {self.mark.type} × {self.mark_multiplicity} Mark to caster";
        }
        
        if (visibility >= 3) {
            var desc = $"A {mark_data.type} {self.type} card";
            if (self.amount > 0) {
                desc += $"\nHeals {self.amount} for caster";
            }
            
            if (self.mark_id_to_remove != "" && self.mark_count_to_remove > 0) {
                var removed_mark_data = res_loader_marks.loaded[? self.mark_id_to_remove];
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
    card_id, "Restoration", card_name, card_sprite, card_rarity, 
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
        target.add_marks(self.transform_from, old_count);
        self.mark.on_apply(target, self.mark_multiplicity * old_count);
        show_debug_message($"Alter {target}: {res_loader_marks[? self.transform_from].type} × {old_count} -> {res_loader_marks[? self.mark]} × {target.count_mark(self.mark)}");
    }
    
    /**
     * @desc Clones the card data
     * @return {Struct.AlterationCardData} The clone
     */
    clone = function() {
        return new AlterationCardData(
            self.uid, self.name, self.sprite, self.rarity,
            self.mark, self.mark_multiplicity, self.transform_from
        );
    }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @return {string} The card description
     */
    describe = function(visibility) {
        var transform_from_mark_data = res_loader_marks[? self.transform_from];
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
    }
}


