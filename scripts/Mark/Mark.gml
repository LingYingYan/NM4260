/// @desc Function Description
/// @param {string} mark_id description
/// @param {string} mark_name Description
/// @param {Asset.GMSprite} mark_sprite description
/// @param {string} dominated_mark description
function Mark(mark_id, mark_name, mark_sprite) constructor {
    uid = mark_id;
    type = mark_name;
    sprite = mark_sprite;
    reactant_coefficient = 1;
    
    /**
     * @desc description
     * @param {Struct.GameCharacterData} target description
     * @param {real} multiplicity description
     */
    on_apply = function(target, multiplicity = 1) { }
    
    describe = function() { }
}

/// @desc Function Description
/// @param {string} mark_id description
/// @param {string} display_name Description
/// @param {Asset.GMSprite} mark_sprite description
function make_mark(mark_id, display_name, mark_sprite) {
    switch (mark_id) {
    	case "mark_fire":
            return new FireMark(mark_id, display_name, mark_sprite);
        case "mark_water":
            return new WaterMark(mark_id, display_name, mark_sprite);
        case "mark_grass":
            return new GrassMark(mark_id, display_name, mark_sprite);
        case "mark_ice":
            return new IceMark(mark_id, display_name, mark_sprite);
        case "mark_lightning":
            return new LightningMark(mark_id, display_name, mark_sprite);
    }
}

function FireMark(mark_id, mark_name, mark_sprite) : Mark(mark_id, mark_name, mark_sprite) constructor {
    reactant_coefficient = 0.5;
    
     /**
     * @desc description
     * @param {Struct.GameCharacterData} target description
     * @param {real} multiplicity description
     */
    on_apply = function(target, multiplicity = 1) {
        multiplicity -= self.reacts_to_grass(target, multiplicity);
        multiplicity -= self.reacts_to_ice(target, multiplicity);
        if (multiplicity > 0) {
            show_debug_message("Fire +" + string(multiplicity));
            target.add_marks(self.uid, multiplicity);
        }
    }
    
    reacts_to_ice = function(target, multiplicity) {
        var count = target.count_mark("mark_ice");
        var n_eliminated = min(count, multiplicity);
        var n_reactions = n_eliminated;
        if (n_eliminated > 0) {
            target.add_marks("mark_grass", -n_eliminated);
        }
        
        if (n_reactions > 0) {
            target.add_marks("mark_water", n_reactions);
            show_debug_message("Water Mark +" + string(n_reactions));
        }
        
        return n_eliminated;
    }
    
    reacts_to_grass = function(target, multiplicity) {
        var count = target.count_mark("mark_grass");
        var n_eliminated = min(count, multiplicity);
        var n_reactions = n_eliminated * 2;
        if (n_eliminated > 0) {
            target.add_marks("mark_grass", -n_eliminated);
        }
        
        if (n_reactions > 0) {
            target.add_status(new Burn(n_reactions));
            show_debug_message("Burn +" + string(n_reactions));
        }
        
        return n_eliminated;
    }
    
    describe = function() {
        return "1 Fire Mark reacts on 1 Grass Mark = Burn × 2\n" +
               "1 Fire Mark reacts on 1 Ice Mark = Water Mark × 1";
    }
} 

function WaterMark(mark_id, mark_name, mark_sprite) : Mark(mark_id, mark_name, mark_sprite) constructor {
    /**
     * @desc description
     * @param {Struct.GameCharacterData} target description
     * @param {real} multiplicity description
     */
    on_apply = function(target, multiplicity = 1) {
        show_debug_message("Water!");
        var dominated_count = target.count_mark("mark_fire");
        var n_eliminated = min(dominated_count, multiplicity);
        var remaining = multiplicity - n_eliminated;
        var n_reactions = n_eliminated;
        if (n_eliminated > 0) {
            target.add_marks("mark_fire", -n_eliminated);
        }
        
        if (n_reactions > 0) {
            target.hp -= n_reactions;
            show_debug_message("Water damage +" + string(n_reactions));
        }
        
        if (remaining > 0) {
            show_debug_message("Water +" + string(remaining));
            target.add_marks(self.uid, remaining);
        }
    }
    
    describe = function() {
        return "1 Water Mark reacts on 1 Fire Mark = Extra Damage + 1";
    }
} 

function GrassMark(mark_id, mark_name, mark_sprite) : Mark(mark_id, mark_name, mark_sprite) constructor { reactant_coefficient 
    reactant_coefficient = 0.5;
    
     /**
     * @desc description
     * @param {Struct.GameCharacterData} target description
     * @param {real} multiplicity description
     */
    on_apply = function(target, multiplicity = 1) {
        var dominated_count = target.count_mark("mark_water");
        var n_eliminated = min(dominated_count, multiplicity);
        var remaining = multiplicity - n_eliminated;
        var n_reactant = n_eliminated * 2;
        if (n_eliminated > 0) {
            target.add_marks("mark_water", -n_eliminated);
        }
        
        if (n_reactant > 0) {
            target.add_status(new Poison(n_reactant));
            show_debug_message("Poison +" + string(n_eliminated));
        }
        
        if (remaining > 0) {
            show_debug_message("Grass +" + string(remaining));
            target.add_marks(self.uid, remaining)
        }
    }
    
    describe = function() {
        return "1 Grass Mark reacts on 1 Water Mark = Poison × 2\n";
    }
} 

function LightningMark(mark_id, mark_name, mark_sprite) : Mark(mark_id, mark_name, mark_sprite) constructor {
    /**
     * @desc description
     * @param {Struct.GameCharacterData} target description
     * @param {real} multiplicity description
     */
    on_apply = function(target, multiplicity = 1) {
        var dominated_count = target.count_mark("mark_water");
        var n_eliminated = min(dominated_count, multiplicity);
        var remaining = multiplicity - n_eliminated;
        var n_reactant = n_eliminated;
        if (n_eliminated > 0) {
            target.add_marks("mark_water", -n_eliminated);
        }
        
        if (n_reactant > 0) {
            target.add_status(new Paralysed(n_reactant));
            show_debug_message("Paralysed +" + string(n_reactant));
        }
        
        if (remaining > 0) {
            show_debug_message("Lightning +" + string(remaining));
            target.add_marks(self.uid, remaining)
        }
    }
    
    describe = function() {
        return "1 Lightning Mark reacts on 1 Water Mark = Paralysed × 1";
    }
} 

function IceMark(mark_id, mark_name, mark_sprite) : Mark(mark_id, mark_name, mark_sprite) constructor {
     /**
     * @desc description
     * @param {Struct.GameCharacterData} target description
     * @param {real} multiplicity description
     */
    on_apply = function(target, multiplicity = 1) {
        var dominated_count = target.count_mark("mark_water");
        var n_eliminated = min(dominated_count, multiplicity);
        var remaining = multiplicity - n_eliminated;
        var n_reactant = floor(n_eliminated / 5);
        if (n_eliminated > 0) {
            target.add_marks("mark_water", -n_eliminated);
        }
        
        if (n_reactant > 0) {
            target.add_status(new Frozen(n_reactant));
            show_debug_message("Frozen +" + string(n_reactant));
        }
        
        if (remaining > 0) {
            show_debug_message("Ice +" + string(remaining));
            target.add_marks(self.uid, remaining)
        }
    }
    
    describe = function() {
        return "1 Ice Mark reacts on 5 Water Marks = Frozen × 1";
    }
} 