/// @desc Function Description
/// @param {id.instance} _agent Description
/// @param {array<Struct.CardData>} _cards Description
/// @param {Struct.UtilityAgent} brain Description
/// @param {Struct.PlayerData} player Description
function make_action_balanced(_agent, _cards, brain, player) {
    var action = new CardAction(
        method({ agent: _agent, cards: _cards }, function() { agent.play(cards); }), 
        _cards, new Dummy(_agent.data), new Dummy(player)
    );
    
    brain.propose_action(action) 
         .consider(new CurveUtilityConsideration(utility_healing, "Healing Ratio to HP Lost", "healing_to_lost_hp_ratio"))
         .consider(new CurveUtilityConsideration(utility_healing, "Healing Ratio to Remaining HP", "healing_to_remaining_ratio"))
         .consider(new CurveUtilityConsideration(utility_healing, "Remaining HP Percentage", "remaining_hp_percentage"))
         .consider_product()
         .and_then()
         .consider(new CurveUtilityConsideration(utility_attack, "Damage Ratio to Player HP", "damage_to_player_hp_ratio"))
         .and_then()
         .consider(new CurveUtilityConsideration(utility_status, "Immediate Damage Ratio to Player HP", "immediate_status_damage_to_player_hp_ratio"))
         .consider(new CurveUtilityConsideration(utility_status, "Projected Total Damage Ratio to Player HP", "projected_status_damage_to_player_hp_ratio"))
         .consider_mean()
         .and_then()
         .consider(new CurveUtilityConsideration(utility_buff_statuses_on_player, "Frozen", "frozen_normalised_duration"))
         .consider(new CurveUtilityConsideration(utility_buff_statuses_on_player, "Paralysed", "paralysed_normalised_duration"))
         .consider(new CurveUtilityConsideration(utility_buff_statuses_on_player, "Bleed", "bleed_normalised_duration"))
         .consider_sum(0.5)
         .consider(new CurveUtilityConsideration(utility_buff_statuses_on_self, "Strength", "projected_extra_damage_to_player_hp_ratio"))
         .and_then()
         .consider(new CurveUtilityConsideration(utility_buff_statuses_on_self, "Coalesence", "projected_healing_to_lost_hp_ratio"))
         .consider(new CurveUtilityConsideration(utility_healing, "Remaining HP Percentage", "remaining_hp_percentage"))
         .consider_product()
         .consider(new CurveUtilityConsideration(utility_self_damage, "Damage Ratio to Remaining HP", "self_damage_ratio_to_remaining_hp"))
         .consider(new CurveUtilityConsideration(utility_status_on_self, "Immediate Damage Ratio to HP", "self_status_immediate_damage_to_hp_ratio"))
         .consider(new CurveUtilityConsideration(utility_status_on_self, "Projected Total Damage Ratio to HP", "self_status_projected_damage_to_hp_ratio"))
         .consider_sum(1.5);
}