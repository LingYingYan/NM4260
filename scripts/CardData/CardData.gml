/**
 * Function Description
 * @param {string} card_type Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {Struct.Mark} mark_data Description
 * @param {real} mark_count description
 * @param {real} attack_damage description    
 * @param {real} heal_amount description
 */
function CardData(
    card_type, card_name, card_sprite, 
    mark_data, mark_count, 
    attack_damage, heal_amount
) constructor {
    type = card_type;
    name = card_name;
    sprite = card_sprite;
    mark = mark_data;
    mark_multiplicity = mark_count;
    damage = attack_damage;
    heal = heal_amount;
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    static apply = function(instigator, target) {
        // self.apply_reflexive_effects(instigator, target);
        switch(self.type) {
            case "Destruction":
                if (target == noone || target == undefined) {
                    show_debug_message("Attacked");   
                    return;     
                }
            
                var old_hp = target.hp;
                target.hp -= self.damage;
                target.hp = max(target.hp, 0);
                show_debug_message($"Attack {target}: HP {old_hp} -> {target.hp}");
                self.apply_marks(instigator, target); 
                break;
            case "Restoration":
                if (instigator == noone || instigator == undefined) {
                    show_debug_message("Healed");
                    return;        
                }
            
                var old_hp = instigator.hp;
                instigator.hp += self.heal;
                instigator.hp = min(instigator.max_hp, instigator.hp);
                show_debug_message($"Heal {instigator}: HP {old_hp} -> {instigator.hp}");
                self.apply_marks(instigator, instigator); 
                break;
        }    
        
        
    }
    
    /**
     * @desc Applies any reflexive card effects
     * @param {id.instance} instigator The caster
     * @param {id.instance} target The target
     */
    static apply_reflexive_effects = function(instigator, target) {
        var old_hp = instigator.hp; 
        instigator.hp -= self.damage_to_self;
        show_debug_message($"{target}: HP {old_hp} -> {target.hp}");
    }
    
    static apply_marks = function(instigator, target) {
        self.mark.on_apply(target, self.mark_multiplicity);
    }
    
    static describe = function() {
        switch (self.type) {
        	case "Destruction":
                return $"Deals {self.damage} {self.mark.type} damage";
            case "Restoration":
                return $"Heals {self.heal} HP";
        }
    }
}


/**
 * Factory function to create a card struct from a resource object
 * @param {id.instance} resource The card resource object instance
 * @return {Struct.CardData} The card data
 */
function make_card_from(resource) {
    var mark = make_mark_from(resource.mark);
    return new CardData(
        resource.type, resource.name, resource.sprite, 
        mark, resource.mark_multiplicity, 
        resource.damage, resource.heal_amount
    );
}
