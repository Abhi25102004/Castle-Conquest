extends Goblin_Class

var Dynamite : PackedScene = preload("res://Characters/Goblin/dynamite.tscn")

@onready var marker: Marker2D = $Marker2D

func HurtBox_Entered(area: Area2D) -> void:
	Knight_Array.append(area.get_parent())

func HurtBox_Exited(area: Area2D) -> void:
	Knight_Array.erase(area.get_parent())
	
func OnAttack() -> void:
	if !Knight_Array.is_empty():
		var Dynamite_instance : Node2D = Dynamite.instantiate()
		Dynamite_instance.Attack = Attack
		Dynamite_instance.position = marker.position
		call_deferred("add_child",Dynamite_instance)

func Stats_Setter() -> void:
	Health = 80
	Attack = 20
	Attack_Speed = randf_range(0.9,1.1)
	Cost = 60
	Speed = randf_range(79,81)
