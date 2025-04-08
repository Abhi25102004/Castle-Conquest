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
	Health = 120
	Attack = 30
	Attack_Speed = randf_range(1.1,1.3)
	Cost = 85
	Speed = randf_range(119,121)
