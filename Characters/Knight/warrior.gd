extends Knight_Class

signal GiveDamageToGoblin

func HurtBox_Entered(area: Area2D) -> void:
	Goblin_Array.append(area.get_parent())
	GiveDamageToGoblin.connect(Callable(area.get_parent(),"Take_Damage_from_knight"))

func HurtBox_Exited(area: Area2D) -> void:
	Goblin_Array.erase(area.get_parent())
	GiveDamageToGoblin.disconnect(Callable(area.get_parent(),"Take_Damage_from_knight"))

func OnAttack() -> void:
	if !Goblin_Array.is_empty():
		GiveDamageToGoblin.emit(Attack)

func Stats_Setter() -> void:
	Health = randf_range(199,201)
	Attack = randf_range(39,41)
	Attack_Speed = randf_range(1.4,1.6)
	Cost = 100
