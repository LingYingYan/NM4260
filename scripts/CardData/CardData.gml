
/**
 * Function Description
 * @param {string} card_type Description
 * @param {string} card_name Description
 * @param {Asset.GMSrpite} card_sprite Description
 * @param {Struct.Mark} mark_data Description
 */
function CardData(card_type, card_name, card_sprite, mark_data) constructor {
    type = card_type;
    sprite = card_sprite;
    mark = mark_data
    
    apply = function(instigator, target) { }
    apply_marks = function(instigator, target) {
        self.mark.on_apply(target);
    }
    
    describe = function() { }
}

function AttackCardData(card_name, card_sprite, attack_damage, mark_data) : CardData("Attack", card_name, card_sprite, mark_data) constructor {
    damage = attack_context.damage;
    apply = function(instigator, target) { 
        var old_hp = target.hp;
        target.hp -= self.damage;
        show_debug_message($"{target}: HP {old_hp} -> {target.hp}");
        self.apply_marks(instigator, target);
    }
        
    describe = function() {
        return $"Deals {self.damage} {self.mark.type} damage";
    }
}

function HealCardData(card_name, card_sprite, heal_amount, mark_data) : CardData("Heal", card_name, card_sprite, mark_data) constructor {
    amount = heal_amount;
    apply = function(instigator, target) { 
        var old_hp = target.hp;
        target.hp += self.amount;
        show_debug_message($"{target}: HP {old_hp} -> {target.hp}");
        self.apply_marks(instigator, target);
    }
        
    describe = function() {
        return $"Heals {self.amount} HP";
    }
}
