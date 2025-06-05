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
		call_deferred("add_child", Dynamite_instance)

func Stats_Setter() -> void:
	Cost = 75
	Speed = randf_range(79, 81)
	Points = 6
	
	match Global.Difficulty:
		"Easy":
			Health = 60
			Attack = 25
			Attack_Speed = 1.5
		"Medium":
			Health = 80
			Attack = 30
			Attack_Speed = 1.3
		"Hard":
			Health = 85
			Attack = 32
			Attack_Speed = 1.25
