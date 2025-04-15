extends Knight_Class

func Stats_Setter() -> void:
	Health = 50
	Attack = 0
	Attack_Speed = 0
	Cost = 40

func Take_Damage_from_Goblin(Power : float) -> void:
	Knight = States.Attack
	Health -= Power

func HurtBox_Entered(area: Area2D) -> void:
	if area.get_parent() is Goblin_Class:
		area.get_parent().GoblinDied.connect(func():
			Goblin_Array.erase(area.get_parent())
			)
		Goblin_Array.append(area.get_parent())

func getAnimation_String() -> String:
	match Knight:
		States.Idle:
			return "Idle"
		States.Attack:
			return "Attack"
		States.Death:
			return "Death"
	return ""

func Game_Loop() -> void :
	
	Knight = States.Death if Health <= 0 else Knight
	
	match Knight:
		States.Idle:
			Animations.play(Animation_String)

		States.Attack:
			await get_tree().create_timer(Attack_Speed).timeout
			Animations.play(Animation_String)
			await Animations.animation_finished
			Knight = States.Idle

		States.Death:
			HitBox_CollisionShape.disabled = true
			if !Goblin_Array.is_empty():
				Goblin_Array[0].HurtBox_CollisionShape.disabled = true
				Goblin_Array[0].Direction = 1
				Goblin_Array[0].Animations.flip_h = false
			Animations.play(Animation_String)
			Animations.scale = Vector2(1.3, 1.3)
			await Animations.animation_finished
			KnightDied.emit()
			call_deferred("queue_free")

	Game_State = true
