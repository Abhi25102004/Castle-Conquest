extends Goblin_Class

signal GiveDamageToKnight

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func HurtBox_Entered(area: Area2D) -> void:
	Knight_Array.append(area.get_parent())
	GiveDamageToKnight.connect(Callable(area.get_parent(),"Take_Damage_from_Goblin"))

func HurtBox_Exited(area: Area2D) -> void:
	Knight_Array.erase(area.get_parent())
	GiveDamageToKnight.disconnect(Callable(area.get_parent(),"Take_Damage_from_Goblin"))
	
func OnAttack() -> void:
	animation_player.play("Explosion")

func Emit_Attack() -> void:
	GiveDamageToKnight.emit(Attack)

func Stats_Setter() -> void:
	Health = randf_range(119,121)
	Attack = randf_range(99,101)
	Attack_Speed = randf_range(1.1,1.3)
	Cost = 75
	Speed = randf_range(89,91)
