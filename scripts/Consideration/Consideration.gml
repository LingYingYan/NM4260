function Consideration() constructor {
    static evaluate = function(context) {
        return 0;
    }
}

function ConstantUtilityConsideration(value) : Consideration() constructor {
    utility = value;
    
    static evaluate = function(context) {
        return self.utility;
    }
}

function CurveUtilityConsideration(anim_curve, channel_name, raw_value_producer) : Consideration() constructor {
    curve = animcurve_get_channel(anim_curve, channel_name);
    raw_value = raw_value_producer;
    
    static evaluate = function(context) {
        if (!struct_exists(context, self.raw_value)) {
            return animcurve_channel_evaluate(self.curve, context[$ self.raw_value]);
        }
        var value = struct_exists(context, self.raw_value);
        
        return animcurve_channel_evaluate(self.curve, context[$ self.raw_value] ?? 0);
    }
}

function CustomFormulaUtilityConsideration(custom_formula) : Consideration() constructor {
    formula = custom_formula;
    
    static evaluate = function(context) {
        return self.formula(context);
    }
}

function CompositeConsideration(inner_considerations) : Consideration() constructor {
    considerations = inner_considerations;
    
    static evaluate = function(context) {
        return 0;
    }
}

function SumUtilConsideration(inner_considerations) : CompositeConsideration(inner_considerations) constructor {
    static evaluate = function(context) {
        var util = 0;
        for (var i = 0; i < array_length(self.considerations); i += 1) {
            util += self.considerations[i].evaluate(context);
        }
        
        return util;
    }
}

function MultiplyUtilConsideration(inner_considerations) : CompositeConsideration(inner_considerations) constructor {
    static evaluate = function(context) {
        var util = 0;
        for (var i = 0; i < array_length(self.considerations); i += 1) {
            util *= self.considerations[i].evaluate(context);
        }
        
        return util;
    }
}

function AverageUtilConsideration(inner_considerations) : CompositeConsideration(inner_considerations) constructor {
    static evaluate = function(context) {
        var util = 0;
        for (var i = 0; i < array_length(self.considerations); i += 1) {
            util += self.considerations[i].evaluate(context);
        }
        
        return util / array_length(self.considerations);
    }
}

function MaxUtilConsideration(inner_consideration) : CompositeConsideration(inner_consideration) constructor {
    static evaluate = function(context) {
        if (array_length(self.considerations) == 0) {
            return 0;
        }
        
        var util = -infinity;
        for (var i = 0; i < array_length(self.considerations); i += 1) {
            util = max(util, self.considerations[i].evaluate(context));
        }
        
        return util;
    }
}

function MinUtilConsideration(inner_consideration) : CompositeConsideration(inner_consideration) constructor {
    static evaluate = function(context) {
        if (array_length(self.considerations) == 0) {
            return 0;
        }
        
        var util = infinity;
        for (var i = 0; i < array_length(self.considerations); i += 1) {
            util = min(util, self.considerations[i].evaluate(context));
        }
        
        return util;
    }
}


