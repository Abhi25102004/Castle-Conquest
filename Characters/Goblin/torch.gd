extends Goblin_Class

signal GiveDamageToKnight

func HurtBox_Entered(area: Area2D) -> void:
	canAttack = true
	GiveDamageToKnight.connect(Callable(area.get_parent(),"Take_Damage_from_Goblin"))

func HurtBox_Exited(area: Area2D) -> void:
	canAttack = false
	GiveDamageToKnight.disconnect(Callable(area.get_parent(),"Take_Damage_from_Goblin"))
	
func OnAttack() -> void:
	GiveDamageToKnight.emit(Attack)
