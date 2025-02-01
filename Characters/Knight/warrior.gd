extends Knight_Class

signal GiveDamageToGoblin

func Setter() -> void:
	CharacterName = "warrior"
	Health = randi_range(100,150)
	Attack = randi_range(25,40)
	Attack_Speed = randf_range(1.5,2)

func HurtBox_Entered(area: Area2D) -> void:
	canAttack = true
	GiveDamageToGoblin.connect(Callable(area.get_parent(),"Take_Damage_from_knight"))

func HurtBox_Exited(area: Area2D) -> void:
	canAttack = false
	GiveDamageToGoblin.disconnect(Callable(area.get_parent(),"Take_Damage_from_knight"))

func OnAttack() -> void:
	GiveDamageToGoblin.emit(Attack)
