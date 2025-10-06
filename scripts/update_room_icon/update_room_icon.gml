function update_room_icon(){
    switch (room_type) {
        //case "treasure": sprite_index = spr_room_treasure; break;
        case "enemy":    sprite_index = spr_enemyRoom; break;
		case "treasure": sprite_index = spr_treasureRoom; break;
		case "bonfire":  sprite_index = spr_bonfire; break;
        default:         sprite_index = spr_dungeonRoom; break;
    }
}