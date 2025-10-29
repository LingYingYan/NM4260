function UtilityAgent() constructor {
    actions = [];
    
    static refresh = function() {
        self.actions = [];
    }
    
    static propose_action = function(action) {
        array_push(self.actions, action);
        return action;
    } 
    
    static make_decision = function(context) {
        var action_weights = [];
        var available_actions = [];
        var best_score = -infinity;
        var best_action = undefined;
        var total = 0;
        for (var i = 0; i < array_length(self.actions); i += 1)  {
            var util = self.actions[i].evaluate(context) * random_range(0.9, 1.1);
            if (util > 0) {
                array_push(action_weights, util);
                array_push(available_actions, self.actions[i]);
                total += util
            }
            
            if (util > best_score) {
                best_score = util;
                best_action = self.actions[i];
            }
        }
        
        var select = random_range(0, total);
        var cumulative = 0;
        for (var i = 0; i < array_length(available_actions); i += 1) {
            cumulative += action_weights[i];
            if (cumulative >= select) {
                return available_actions[i];
            }
        }
        
        return best_action;
    }
}