/**
 * Function Description
 * @param {Function} _on_performed Description
 */
function Action(_on_performed) constructor {
    callback = _on_performed;
    next_composite_index = 0;
    considerations = [];
    consideration_weights = [];
    
    static copy_considerations = function() {
        var copied = [];
        var n_temp = array_length(self.considerations) - (self.next_composite_index);
        array_copy(copied, 0, self.considerations, self.next_composite_index, n_temp);
        return copied;
    }
    
    static clear_temp_considerations = function() {
        var n_temp = array_length(self.considerations) - (self.next_composite_index)
        array_delete(self.considerations, self.next_composite_index, n_temp);
        array_delete(self.consideration_weights, self.next_composite_index, n_temp);
    }
    
    static consider = function(consideration, weight = 1) {
        array_push(self.considerations, consideration);
        array_push(self.consideration_weights, max(0, weight));
        return self;
    }
    
    static and_then = function() {
        self.next_composite_index = array_length(self.considerations);
        return self;
    }
    
    static consider_sum = function(weight = 1) {
        var sum_consideration = new SumUtilConsideration(self.copy_considerations());
        self.clear_temp_considerations();
        array_push(self.considerations, sum_consideration);
        array_push(self.consideration_weights, max(0, weight));
        return self;
    }
    
    static consider_product = function(weight = 1) {
        var prod_consideration = new MultiplyUtilConsideration(self.copy_considerations());
        self.clear_temp_considerations();
        array_push(self.considerations, prod_consideration);
        array_push(self.consideration_weights, max(0, weight));
        return self;
    }
    
    static consider_mean = function(weight = 1) {
        var avg_consideration = new AverageUtilConsideration(self.copy_considerations());
        self.clear_temp_considerations();
        array_push(self.considerations, avg_consideration);
        array_push(self.consideration_weights, max(0, weight));
        return self;
    }
    
    static consider_max = function(weight = 1) {
        var max_consideration = new MaxUtilConsideration(self.copy_considerations());
        self.clear_temp_considerations();
        array_push(self.considerations, max_consideration);
        array_push(self.consideration_weights, max(0, weight));
        return self;
    }
    
    static consider_min = function(weight = 1) {
        var min_consideration = new MinUtilConsideration(self.copy_considerations());
        self.clear_temp_considerations();
        array_push(self.considerations, min_consideration);
        array_push(self.consideration_weights, max(0, weight));
        return self;
    }
    
    static evaluate = function(context) { 
        if (array_length(self.considerations) == 0) {
            return 0;
        }
        
        var normalised_weights = [];
        var weight_sum = 0;
        for (var i = 0; i < array_length(self.consideration_weights); i += 1) {
            weight_sum += self.consideration_weights[i];
        }
        
        for (var i = 0; i < array_length(self.consideration_weights); i += 1) {
            array_push(normalised_weights, self.consideration_weights[i] / weight_sum);
        }
        
        var util = 0;
        for (var i = 0; i < array_length(self.considerations); i += 1) {
            util += normalised_weights[i] * self.considerations[i].evaluate(context);
        }
        
        return util;
    }
    
    static perform = function() {
        self.callback();
    }
}