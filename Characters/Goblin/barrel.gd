extends Goblin_Class

signal GiveDamageToKnight

func HurtBox_Entered(area: Area2D) -> void:
	Knight_Array.append(area.get_parent())
	GiveDamageToKnight.connect(Callable(area.get_parent(),"Take_Damage_from_Goblin"))

func HurtBox_Exited(area: Area2D) -> void:
	Knight_Array.erase(area.get_parent())
	GiveDamageToKnight.disconnect(Callable(area.get_parent(),"Take_Damage_from_Goblin"))
	
func OnAttack() -> void:
	if !Knight_Array.is_empty():
		GiveDamageToKnight.emit(Attack)
		GoblinDied.emit()
		call_deferred("queue_free")

func Stats_Setter() -> void:
	Health = randf_range(149,151)
	Attack = 300
	Attack_Speed = randf_range(0.4,0.6)
	Cost = 75
	Speed = randf_range(119,121)
