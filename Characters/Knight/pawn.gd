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
	Cost = 50
	
	match Global.Difficulty:
		"Easy":
			Health = 100
			Attack = 25
			Attack_Speed = 1
		"Medium":
			Health = 100
			Attack = 20
			Attack_Speed = 1
		"Hard":
			Health = 95
			Attack = 20
			Attack_Speed = 1.0
