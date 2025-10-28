/**
 * Function Description
 * @param {string} card_id Description
 * @param {string} card_type Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 */
function CardData(card_id, card_type, card_name, card_sprite, card_rarity, mark_id) constructor {
    uid = card_id;
    type = card_type;
    name = card_name;
    sprite = card_sprite;
    rarity = card_rarity;
    mark = make_mark(mark_id);
    
    effects_on_target = [];
    effects_on_caster = [];
    
    static get_number_of_effects = function() {
        return array_length(self.effects_on_caster) + array_length(self.effects_on_target);
    }
    
    static get_power_multiplier_from_instigator = function(instigator) {
        return instigator.get_attribute($"{string_lower(self.mark.type)}_power_mult") +
               instigator.get_attribute($"{string_lower(self.type)}_power_mult");
    }
    
    static get_power_multiplier_from_target = function(target) {
        return target.get_attribute($"{string_lower(self.mark.type)}_weakness_mult");
    }
    
    static get_power_multiplier = function(instigator, target) {
        var instigator_mult = instigator == undefined ? 0 : self.get_power_multiplier_from_instigator(instigator);
        var target_mult = target == undefined ? 0 : self.get_power_multiplier_from_target(target);
        return instigator_mult + target_mult;
    }
    
    static get_weight = function() {
        return 5 - self.rarity;
    }
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} owner The caster
     * @param {Struct.GameCharacterData} opponent The target
     * @param {real} index The index of the effect to execute
     */
    static apply_effect = function(owner, opponent, index) { 
        if (index < array_length(self.effects_on_caster)) {
            self.effects_on_caster[index].apply(new EffectApplicationArgs(owner, owner, self.get_power_multiplier(owner, owner)));
        } else {
            index -= array_length(self.effects_on_caster);
            self.effects_on_target[index].apply(new EffectApplicationArgs(owner, opponent, self.get_power_multiplier(owner, opponent)));
        }
    }
    
    /**
     * @desc Applies the card effects
     * @param {Struct.Dummy} owner The caster
     * @param {Struct.Dummy} opponent The target
     */
    static simulate_effects = function(owner, opponent) {
        for (var i = 0; i < array_length(self.effects_on_caster); i += 1) {
            self.effects_on_caster[i].apply(new EffectApplicationArgs(owner, owner, self.get_power_multiplier(owner, owner)));
        }
        
        for (var i = 0; i < array_length(self.effects_on_target); i += 1) {
            self.effects_on_target[i].apply(new EffectApplicationArgs(owner, opponent, self.get_power_multiplier(owner, opponent)));
        }
    }
    
    /**
     * @desc Describe the card
     * @param {real} visibility Visibility
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     * @param {bool} highlight description
     * @param {Struct} focus description
     * @return {string} The card description
     */
    static describe = function(visibility, instigator, target, highlight = false, focus = undefined) {
        if (visibility < 1) {
            return "";
        }
        
        if (visibility < 2) {
            return $"A {self.mark.get_label(highlight)} card";
        }
        
        if (visibility < 3) {
            return $"A {self.mark.get_label(highlight)} [b]{self.type}[/b] card";
        }
        
        var texts = [];
        var mult = self.get_power_multiplier(instigator, target);
        var vague = visibility < 4;
        var curr = 0;
        if (array_length(self.effects_on_caster) > 0) {
            var text = $"[bi]Caster[/bi]:"
            for (var i = 0; i < array_length(self.effects_on_caster); i += 1) {
            	var effect = self.effects_on_caster[i];
                var curr_text = $"\n  {effect.to_string(new EffectApplicationArgs(instigator, target, mult), vague, highlight)}";
                if (focus != undefined && curr == focus.index) {
                    curr_text = $"[scale,{focus.scale}]{curr_text}[/s]";
                }
                
                curr += 1;
                text += curr_text;
            }
            
            array_push(texts, text);
        }
        
        if (array_length(self.effects_on_target) > 0) {
            var text = $"[bi]Target[/bi]:"
            for (var i = 0; i < array_length(self.effects_on_target); i += 1) {
            	var effect = self.effects_on_target[i];
                var curr_text = $"\n  {effect.to_string(new EffectApplicationArgs(instigator, target, mult), vague, highlight)}";
                if (focus != undefined && curr == focus.index) {
                    curr_text = $"[scale,{focus.scale}]{curr_text}[/s]";
                }
                
                curr += 1;
                text += curr_text;
            }
            
            array_push(texts, text);
        }
        
        return string_join_ext("\n", texts);
    }
}

/**
 * Function Description
 * @param {string} card_id Description
 * @param {string} card_type Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 * @param {Struct} args Read from JSON
 */
function create_card_data(card_id, card_type, card_name, card_sprite, card_rarity, mark_id, args) {
    var card_data = new CardData(card_id, card_type, card_name, card_sprite, card_rarity, mark_id);
    for (var i = 0; i < array_length(args.effects_on_target); i += 1) {
        array_push(card_data.effects_on_target, make_effect(args.effects_on_target[i], card_data));
    }
    
    for (var i = 0; i < array_length(args.effects_on_caster); i += 1) {
        array_push(card_data.effects_on_caster, make_effect(args.effects_on_caster[i], card_data));
    }
    
    return card_data;
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

