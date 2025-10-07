/**
 * Function Description
 * @param {string} card_id Description
 * @param {string} card_type Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 * @param {real} mark_count description
 * @param {real} attack_damage description    
 * @param {real} heal_amount description
 */
function CardData(
    card_id, card_type, card_name, card_sprite, card_rarity,
    mark_id, mark_count, 
    attack_damage, heal_amount
) constructor {
    uid = card_id;
    type = card_type;
    name = card_name;
    sprite = card_sprite;
    rarity = card_rarity;
    mark = mark_id;
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
        var mark = res_loader_marks.loaded[? self.mark];
        mark.on_apply(target, mark_multiplicity);
    }
    
    static describe = function() {
        var mark = res_loader_marks.loaded[? self.mark];
        switch (self.type) {
        	case "Destruction":
                return $"Deals {self.damage} {mark.type} damage";
            case "Restoration":
                return $"Heals {self.heal} HP";
        }
    }
    
    static clone = function() {
        return new CardData(
            self.uid, self.type, self.name, self.sprite, self.rarity,
            self.mark, self.mark_multiplicity,
            self.damage, self.heal
        );
    }
}



