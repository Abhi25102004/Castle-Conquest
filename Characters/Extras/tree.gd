extends Knight_Class

func Stats_Setter() -> void:
	Health = 300
	Attack = 0
	Attack_Speed = 0
	Cost = 60	
	Character_value = 5


func Take_Damage_from_Goblin(Power : float) -> void:
	Knight = States.Attack
	Health -= Power

func getAnimation_String() -> String:
	match Knight:
		States.Idle:
			return "Idle"
		States.Attack:
			return "Attack"
		States.Death:
			return "Death"
	return ""

func Game_Loop() -> void:
	match Knight:
		States.Idle:
			Animations.play(Animation_String)
		States.Attack:
			await get_tree().create_timer(Attack_Speed).timeout
			Animations.play(Animation_String)
			await Animations.animation_finished
			Knight = States.Idle
		States.Death:
			Animations.play(Animation_String)
			await Animations.animation_finished
			KnightDied.emit()
			call_deferred("queue_free")
	Game_State = true
