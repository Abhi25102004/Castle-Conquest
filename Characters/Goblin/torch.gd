extends Goblin_Class

signal GiveDamageToKnight

func HurtBox_Entered(area: Area2D) -> void:
	Knight_Array.append(area.get_parent())
	GiveDamageToKnight.connect(Callable(area.get_parent(),"Take_Damage_from_Goblin"))

func HurtBox_Exited(area: Area2D) -> void:
	Knight_Array.erase(area.get_parent())
	GiveDamageToKnight.disconnect(Callable(area.get_parent(),"Take_Damage_from_Goblin"))
	
func OnAttack() -> void:
	GiveDamageToKnight.emit(Attack)
