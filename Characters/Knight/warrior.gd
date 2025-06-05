extends Knight_Class

signal GiveDamageToGoblin

func HurtBox_Entered(area: Area2D) -> void:
	Goblin_Array.append(area.get_parent())
	GiveDamageToGoblin.connect(Callable(area.get_parent(), "Take_Damage_from_knight"))

func HurtBox_Exited(area: Area2D) -> void:
	Goblin_Array.erase(area.get_parent())
	GiveDamageToGoblin.disconnect(Callable(area.get_parent(), "Take_Damage_from_knight"))

func OnAttack() -> void:
	if !Goblin_Array.is_empty():
		GiveDamageToGoblin.emit(Attack)

func Stats_Setter() -> void:
	Cost = 100
	Points = 4

	match Global.Difficulty:
		"Easy":
			Health = 180
			Attack = 40
			Attack_Speed = 1.2
		"Medium":
			Health = 160
			Attack = 35
			Attack_Speed = 1.3
		"Hard":
			Health = 160
			Attack = 32
			Attack_Speed = 1.3
