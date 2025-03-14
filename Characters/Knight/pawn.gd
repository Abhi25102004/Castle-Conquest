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
