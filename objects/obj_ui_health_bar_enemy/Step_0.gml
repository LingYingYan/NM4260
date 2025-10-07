if (instance_exists(obj_enemy)) {
    self.current = obj_enemy.data.hp;
    self.max_value = obj_enemy.data.max_hp;
}