function make_attack_card(card_name, card_sprite, attack_context, special_data) {
    return {
        type: "Attack",
        sprite: card_sprite,
        mark: special_data.mark,
        mark_count: special_data.mark_count,
        attack_type: attack_context.type,
        damage: attack_context.damage,
        apply: function(instigator, target) {
            var old_hp = target.hp;
            target.hp -= self.damage;
            show_debug_message($"{target}: HP {old_hp} -> {target.hp}");
        },
        
        describe: function() {
            return $"Deals {self.damage} damage";
        }
    };
}

function make_heal_card(card_name, card_sprite, heal_context, special_data) {
    return {
        type: "Heal",
        sprite: card_sprite,
        mark: special_data.mark,
        mark_count: special_data.mark_count,
        amount: heal_context.amount,
        apply: function(instigator, target) {
            var old_hp = target.hp;
            target.hp += self.amount;
            show_debug_message($"{target}: HP {old_hp} -> {target.hp}");
        },
        
        describe: function() {
            return $"Heals {self.amount} HP";
        }
    };
}
