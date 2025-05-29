extends Goblin_Class

signal GiveDamageToKnight

func HurtBox_Entered(area: Area2D) -> void:
	Knight_Array.append(area.get_parent())
	GiveDamageToKnight.connect(Callable(area.get_parent(), "Take_Damage_from_Goblin"))

func HurtBox_Exited(area: Area2D) -> void:
	Knight_Array.erase(area.get_parent())
	GiveDamageToKnight.disconnect(Callable(area.get_parent(), "Take_Damage_from_Goblin"))

func OnAttack() -> void:
	if !Knight_Array.is_empty():
		GiveDamageToKnight.emit(Attack)

func Stats_Setter() -> void:
	Cost = 50
	Speed = randf_range(119, 121)
	
	match Global.Difficulty:
		"Easy":
			Health = 80
			Attack = 20
			Attack_Speed = 1.2
		"Medium":
			Health = 100
			Attack = 25
			Attack_Speed = 1.1
		"Hard":
			Health = 110
			Attack = 28
			Attack_Speed = 1.05
